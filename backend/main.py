from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta
from typing import List

from models import Usuario, Agendamento, HorarioDisponivel, Servico, Notificacao, StatusAgendamento, CategoriaServico ,TipoUsuario
from dependencies import (
    get_db, get_password_hash, authenticate_user, create_access_token,
    get_current_user, get_current_admin, ACCESS_TOKEN_EXPIRE_MINUTES, verify_password
)
from schemas import (
    UsuarioCreate, UsuarioResponse, Token, ServicoCreate, ServicoResponse,
    HorarioCreate, HorarioResponse, AgendamentoCreate, AgendamentoResponse,
    NotificacaoResponse, AlterarSenhaSchema
)

app = FastAPI(title="AAMAVASF API")


# ========== Auth endpoints ==========
@app.post("/registrar", response_model=UsuarioResponse)
def registrar(usuario: UsuarioCreate, db: Session = Depends(get_db)):
    if db.query(Usuario).filter(Usuario.email == usuario.email).first():
        raise HTTPException(status_code=400, detail="Email already registered")
    if db.query(Usuario).filter(Usuario.cpf == usuario.cpf).first():
        raise HTTPException(status_code=400, detail="CPF already registered")
    hashed = get_password_hash(usuario.senha)
    db_usuario = Usuario(
        nome=usuario.nome,
        email=usuario.email,
        senha_hash=hashed,
        cpf=usuario.cpf,
        telefone=usuario.telefone,
        nome_dependente=usuario.nome_dependente,
        data_nasc_dep=usuario.data_nasc_dep
    )
    db.add(db_usuario)
    db.commit()
    db.refresh(db_usuario)
    return db_usuario


@app.post("/token", response_model=Token)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    access_token = create_access_token(
        data={"sub": user.email},
        expires_delta=timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    return {"access_token": access_token, "token_type": "bearer"}


# ========== Usuários ==========
@app.get("/usuarios/me", response_model=UsuarioResponse)
def read_users_me(current_user: Usuario = Depends(get_current_user)):
    return current_user


@app.get("/usuarios/agendamentos", response_model=List[AgendamentoResponse])
def visualizar_agendamentos(current_user: Usuario = Depends(get_current_user), db: Session = Depends(get_db)):
    agendamentos = db.query(Agendamento).filter(Agendamento.usuario_id == current_user.id).all()
    result = []
    for a in agendamentos:
        horario_resp = HorarioResponse(
            id=a.horario.id,
            datahora_inicio=a.horario.datahora_inicio,
            vagas_total=a.horario.vagas_total,
            vagas_ocupadas=a.horario.vagas_ocupadas,
            local=a.horario.local,
            observacao=a.horario.observacao,
            servico_id=a.horario.servico_id,
            tem_vagas=a.horario.temVagas()
        )
        result.append(AgendamentoResponse(
            id=a.id,
            data_agendamento=a.data_agendamento,
            status=a.status,
            data_cancelamento=a.data_cancelamento,
            compareceu=a.compareceu,
            usuario_id=a.usuario_id,
            horario=horario_resp,
            servico_titulo=a.horario.servico.titulo
        ))
    return result


@app.post("/usuarios/agendar", response_model=AgendamentoResponse)
def agendar(agendamento: AgendamentoCreate, current_user: Usuario = Depends(get_current_user), db: Session = Depends(get_db)):
    horario = db.query(HorarioDisponivel).filter(HorarioDisponivel.id == agendamento.horario_id).first()
    if not horario:
        raise HTTPException(status_code=404, detail="Horário não encontrado")
    if not horario.temVagas():
        raise HTTPException(status_code=400, detail="Sem vagas disponíveis")
    if not horario.reservaVagas():
        raise HTTPException(status_code=400, detail="Falha ao reservar vaga")
    db_agendamento = Agendamento(usuario_id=current_user.id, horario_id=horario.id)
    db.add(db_agendamento)
    db.commit()
    db.refresh(db_agendamento)
    # Notificação
    notif = Notificacao(
        titulo="Agendamento criado",
        mensagem=f"Seu agendamento para {horario.servico.titulo} em {horario.datahora_inicio} foi criado.",
        usuario_id=current_user.id,
        tipo="agendamento"
    )
    db.add(notif)
    db.commit()
    horario_resp = HorarioResponse(
            id=horario.id,
            datahora_inicio=horario.datahora_inicio,
            vagas_total=horario.vagas_total,
            vagas_ocupadas=horario.vagas_ocupadas,
            local=horario.local,
            observacao=horario.observacao,
            servico_id=horario.servico_id,
            tem_vagas=horario.temVagas()
        )
    return AgendamentoResponse(
        id=db_agendamento.id,
        data_agendamento=db_agendamento.data_agendamento,
        status=db_agendamento.status,
        data_cancelamento=db_agendamento.data_cancelamento,
        compareceu=db_agendamento.compareceu,
        usuario_id=db_agendamento.usuario_id,
        horario=horario_resp,
        servico_titulo=horario.servico.titulo
    )


@app.delete("/usuarios/cancelar/{agendamento_id}")
def cancelar_agendamento(agendamento_id: int, current_user: Usuario = Depends(get_current_user), db: Session = Depends(get_db)):
    agendamento = db.query(Agendamento).filter(Agendamento.id == agendamento_id, Agendamento.usuario_id == current_user.id).first()
    if not agendamento:
        raise HTTPException(status_code=404, detail="Agendamento não encontrado")
    if agendamento.status == StatusAgendamento.CANCELADO:
        raise HTTPException(status_code=400, detail="Agendamento já cancelado")
    agendamento.cancelar(db)
    notif = Notificacao(
        titulo="Agendamento cancelado",
        mensagem=f"Seu agendamento para {agendamento.horario.servico.titulo} foi cancelado.",
        usuario_id=current_user.id,
        tipo="cancelamento"
    )
    db.add(notif)
    db.commit()
    return {"message": "Agendamento cancelado com sucesso"}


# ========== Admin ==========
@app.get("/admin/agendamentos", response_model=List[AgendamentoResponse])
def visualizar_todos_agendamentos(admin: Usuario = Depends(get_current_admin), db: Session = Depends(get_db)):
    agendamentos = db.query(Agendamento).all()
    result = []
    for a in agendamentos:
        horario_resp = HorarioResponse.model_validate(a.horario)
        horario_resp.temVagas = a.horario.temVagas()
        result.append(AgendamentoResponse(
            id=a.id,
            data_agendamento=a.data_agendamento,
            status=a.status,
            data_cancelamento=a.data_cancelamento,
            compareceu=a.compareceu,
            usuario_id=a.usuario_id,
            horario=horario_resp,
            servico_titulo=a.horario.servico.titulo
        ))
    return result


# ========== Serviços e Horários ==========
@app.get("/servicos", response_model=List[ServicoResponse])
def listar_servicos(db: Session = Depends(get_db)):
    servicos = db.query(Servico).filter(Servico.ativo == True).all()
    # Para cada serviço, adicionar o nome da categoria
    result = []
    for s in servicos:
        resp = ServicoResponse(
            id=s.id,
            titulo=s.titulo,
            descricao=s.descricao,
            duracao=s.duracao,
            valor=s.valor,
            ativo=s.ativo,
            id_categoria=s.id_categoria,
            categoria_nome=s.categoria_rel.nome if s.categoria_rel else None
        )
        result.append(resp)
    return result


@app.post("/servicos", response_model=ServicoResponse)
def criar_servico(servico: ServicoCreate, admin: Usuario = Depends(get_current_admin), db: Session = Depends(get_db)):
    # Verifica se a categoria existe
    categoria = db.query(CategoriaServico).filter(CategoriaServico.id_categoria == servico.id_categoria).first()
    if not categoria:
        raise HTTPException(status_code=404, detail="Categoria não encontrada")
    
    db_servico = Servico(
        titulo=servico.titulo,
        descricao=servico.descricao,
        duracao=servico.duracao,
        valor=servico.valor,
        id_categoria=servico.id_categoria
    )
    db.add(db_servico)
    db.commit()
    db.refresh(db_servico)
    return db_servico


@app.post("/servicos/{servico_id}/horarios", response_model=HorarioResponse)
def adicionar_horario(servico_id: int, horario: HorarioCreate, admin: Usuario = Depends(get_current_admin), db: Session = Depends(get_db)):
    servico = db.query(Servico).filter(Servico.id == servico_id).first()
    if not servico:
        raise HTTPException(status_code=404, detail="Serviço não encontrado")
    db_horario = HorarioDisponivel(
        datahora_inicio=horario.datahora_inicio,
        vagas_total=horario.vagas_total,
        local=horario.local,
        observacao=horario.observacao,
        servico_id=servico_id
    )
    db.add(db_horario)
    db.commit()
    db.refresh(db_horario)
    resp = HorarioResponse.model_validate(db_horario)
    resp.temVagas = db_horario.temVagas()
    return resp


@app.delete("/horarios/{horario_id}")
def remover_horario(horario_id: int, admin: Usuario = Depends(get_current_admin), db: Session = Depends(get_db)):
    horario = db.query(HorarioDisponivel).filter(HorarioDisponivel.id == horario_id).first()
    if not horario:
        raise HTTPException(status_code=404, detail="Horário não encontrado")
    if db.query(Agendamento).filter(Agendamento.horario_id == horario_id, Agendamento.status != StatusAgendamento.CANCELADO).first():
        raise HTTPException(status_code=400, detail="Não é possível remover horário com agendamentos ativos")
    db.delete(horario)
    db.commit()
    return {"message": "Horário removido com sucesso"}


# ========== Notificações ==========
@app.get("/notificacoes", response_model=List[NotificacaoResponse])
def listar_notificacoes(current_user: Usuario = Depends(get_current_user), db: Session = Depends(get_db)):
    notificacoes = db.query(Notificacao).filter(Notificacao.usuario_id == current_user.id).order_by(Notificacao.data_envio.desc()).all()
    return notificacoes


@app.put("/notificacoes/{notificacao_id}/marcar-lida")
def marcar_notificacao_lida(notificacao_id: int, current_user: Usuario = Depends(get_current_user), db: Session = Depends(get_db)):
    notificacao = db.query(Notificacao).filter(Notificacao.id == notificacao_id, Notificacao.usuario_id == current_user.id).first()
    if not notificacao:
        raise HTTPException(status_code=404, detail="Notificação não encontrada")
    notificacao.marcarComoLida()
    db.commit()
    return {"message": "Notificação marcada como lida"}

# =========== Alterar senha ==========
@app.post("/usuarios/alterar-senha")
def alterar_senha(
    dados: AlterarSenhaSchema,
    current_user: Usuario = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Verifica se a senha atual está correta
    if not verify_password(dados.senha_atual, current_user.senha_hash):
        raise HTTPException(status_code=400, detail="Senha atual incorreta")
    
    # Validação básica da nova senha (ex: mínimo 6 caracteres)
    if len(dados.nova_senha) < 6:
        raise HTTPException(status_code=400, detail="A nova senha deve ter pelo menos 6 caracteres")
    
    # Gera o hash da nova senha
    nova_senha_hash = get_password_hash(dados.nova_senha)
    
    # Atualiza no banco
    current_user.senha_hash = nova_senha_hash
    db.commit()
    
    # (Opcional) Cria uma notificação de segurança
    notif = Notificacao(
        titulo="Senha alterada",
        mensagem="Sua senha foi alterada com sucesso.",
        usuario_id=current_user.id,
        tipo="seguranca"
    )
    db.add(notif)
    db.commit()
    
    return {"message": "Senha alterada com sucesso"}

# ========== Health Check ==========
@app.get("/")
def root():
    return {"message": "API de Agendamentos funcionando!"}