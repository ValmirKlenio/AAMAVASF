from pydantic import BaseModel, EmailStr
from datetime import datetime, date
from typing import Optional, List
from models import TipoUsuario, StatusAgendamento, CategoriaServico


class UsuarioCreate(BaseModel):
    nome: str
    email: EmailStr
    senha: str
    cpf: str
    telefone: str
    nome_dependente: Optional[str] = None
    data_nasc_dep: Optional[date] = None


class UsuarioResponse(BaseModel):
    id: int
    nome: str
    email: str
    cpf: str
    telefone: str
    tipo: TipoUsuario
    data_cadastro: datetime
    nome_dependente: Optional[str]
    data_nasc_dep: Optional[date]

    class Config:
        from_attributes = True


class Token(BaseModel):
    access_token: str
    token_type: str


class ServicoCreate(BaseModel):
    titulo: str
    descricao: Optional[str] = None
    duracao: int
    valor: float
    id_categoria: int


class ServicoResponse(BaseModel):
    id: int
    titulo: str
    descricao: Optional[str]
    duracao: int
    valor: float
    ativo: bool
    id_categoria: int
    categoria_nome: Optional[str] = None

    class Config:
        from_attributes = True


class HorarioCreate(BaseModel):
    datahora_inicio: datetime
    vagas_total: int = 1
    local: str
    observacao: Optional[str] = None


class HorarioResponse(BaseModel):
    id: int
    datahora_inicio: datetime
    vagas_total: int
    vagas_ocupadas: int
    local: str
    observacao: Optional[str]
    servico_id: int
    tem_vagas: bool

    class Config:
        from_attributes = True


class AgendamentoCreate(BaseModel):
    horario_id: int


class AgendamentoResponse(BaseModel):
    id: int
    data_agendamento: datetime
    status: StatusAgendamento
    data_cancelamento: Optional[datetime]
    compareceu: bool
    usuario_id: int
    horario: HorarioResponse
    servico_titulo: Optional[str] = None
    id_agendamento: Optional[int] = None
    id_horario: Optional[int] = None
    id_servico: Optional[int] = None
    titulo: Optional[str] = None
    descricao: Optional[str] = None
    data: Optional[date] = None
    hora: Optional[str] = None
    id_categoria: Optional[int] = None
    categoria_nome: Optional[str] = None
    categoria_cor: Optional[str] = None

    class Config:
        from_attributes = True


class NotificacaoResponse(BaseModel):
    id: int
    titulo: str
    mensagem: str
    data_envio: datetime
    lida: bool
    tipo: str

    class Config:
        from_attributes = True
