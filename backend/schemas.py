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
    nomeDependente: Optional[str] = None
    dataNascDep: Optional[date] = None


class UsuarioResponse(BaseModel):
    id: int
    nome: str
    email: str
    cpf: str
    telefone: str
    tipo: TipoUsuario
    dataCadastro: datetime
    nomeDependente: Optional[str]
    dataNascDep: Optional[date]

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
    categoria: CategoriaServico


class ServicoResponse(BaseModel):
    id: int
    titulo: str
    descricao: Optional[str]
    duracao: int
    valor: float
    ativo: bool
    categoria: CategoriaServico

    class Config:
        from_attributes = True


class HorarioCreate(BaseModel):
    datahoraInicio: datetime
    vagasTotal: int = 1
    local: str
    observacao: Optional[str] = None


class HorarioResponse(BaseModel):
    id: int
    datahoraInicio: datetime
    vagasTotal: int
    vagasOcupadas: int
    local: str
    observacao: Optional[str]
    servico_id: int
    temVagas: bool

    class Config:
        from_attributes = True


class AgendamentoCreate(BaseModel):
    horario_id: int


class AgendamentoResponse(BaseModel):
    id: int
    dataAgendamento: datetime
    status: StatusAgendamento
    dataCancelamento: Optional[datetime]
    compareceu: bool
    usuario_id: int
    horario: HorarioResponse
    servico_titulo: Optional[str] = None

    class Config:
        from_attributes = True


class NotificacaoResponse(BaseModel):
    id: int
    titulo: str
    mensagem: str
    dataEnvio: datetime
    lida: bool
    tipo: str

    class Config:
        from_attributes = True