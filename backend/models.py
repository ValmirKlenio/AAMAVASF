from sqlalchemy import Column, Integer, String, Boolean, DateTime, Float, Enum, ForeignKey, Date
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import relationship
from datetime import datetime
import enum

Base = declarative_base()

# Enums
class TipoUsuario(str, enum.Enum):
    CLIENTE = "cliente"
    ADMIN = "admin"

class StatusAgendamento(str, enum.Enum):
    PENDENTE = "pendente"
    CONFIRMADO = "confirmado"
    CANCELADO = "cancelado"
    REALIZADO = "realizado"

class CategoriaServico(Base):
    __tablename__ = "categoria_servico"
    id_categoria = Column(Integer, primary_key=True, index=True)
    nome = Column(String(50), nullable=False)
    descricao = Column(String(200))
    cor = Column(String(7))

    servicos = relationship("Servico", back_populates="categoria_rel")


class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    senha_hash = Column(String, nullable=False)
    cpf = Column(String, unique=True, index=True, nullable=False)
    telefone = Column(String)
    tipo = Column(Enum(TipoUsuario), default=TipoUsuario.CLIENTE)
    data_cadastro = Column(DateTime, default=datetime.utcnow)
    nome_dependente = Column(String, nullable=True)
    data_nasc_dep = Column(Date, nullable=True)

    agendamentos = relationship("Agendamento", back_populates="usuario")
    notificacoes = relationship("Notificacao", back_populates="usuario")


class Servico(Base):
    __tablename__ = "servicos"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String, nullable=False)
    descricao = Column(String)
    duracao = Column(Integer)  # minutes
    valor = Column(Float)
    ativo = Column(Boolean, default=True)
    id_categoria= Column(Integer, ForeignKey("categoria_servico.id_categoria"), nullable=False)

    categoria_rel = relationship("CategoriaServico", back_populates="servicos")
    horarios = relationship("HorarioDisponivel", back_populates="servico")


class HorarioDisponivel(Base):
    __tablename__ = "horarios_disponiveis"

    id = Column(Integer, primary_key=True, index=True)
    datahora_inicio = Column(DateTime, nullable=False, index=True)
    vagas_total = Column(Integer, default=1)
    vagas_ocupadas = Column(Integer, default=0)
    local = Column(String)
    observacao = Column(String)
    servico_id = Column(Integer, ForeignKey("servicos.id"), nullable=False)

    servico = relationship("Servico", back_populates="horarios")
    agendamentos = relationship("Agendamento", back_populates="horario")

    def temVagas(self) -> bool:
        return self.vagas_ocupadas < self.vagas_total

    def reservaVagas(self, quantidade: int = 1) -> bool:
        if self.vagas_ocupadas + quantidade <= self.vagas_total:
            self.vagas_ocupadas += quantidade
            return True
        return False


class Agendamento(Base):
    __tablename__ = "agendamentos"

    id = Column(Integer, primary_key=True, index=True)
    data_agendamento = Column(DateTime, default=datetime.utcnow)
    status = Column(Enum(StatusAgendamento), default=StatusAgendamento.PENDENTE)
    data_cancelamento = Column(DateTime, nullable=True)
    compareceu = Column(Boolean, default=False)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    horario_id = Column(Integer, ForeignKey("horarios_disponiveis.id"), nullable=False)

    usuario = relationship("Usuario", back_populates="agendamentos")
    horario = relationship("HorarioDisponivel", back_populates="agendamentos")

    def cancelar(self, db_session):
        self.status = StatusAgendamento.CANCELADO
        self.data_cancelamento = datetime.utcnow()
        # libera vaga
        self.horario.vagas_ocupadas -= 1
        db_session.commit()

    def confirmarPresenca(self):
        self.compareceu = True
        self.status = StatusAgendamento.REALIZADO


class Notificacao(Base):
    __tablename__ = "notificacoes"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String, nullable=False)
    mensagem = Column(String)
    data_envio = Column(DateTime, default=datetime.utcnow)
    lida = Column(Boolean, default=False)
    tipo = Column(String)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)

    usuario = relationship("Usuario", back_populates="notificacoes")

    def marcarComoLida(self):
        self.lida = True