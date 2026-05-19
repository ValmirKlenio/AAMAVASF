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

class CategoriaServico(str, enum.Enum):
    CONSULTA = "consulta"
    EXAMEN = "examen"
    PROCEDIMENTO = "procedimento"
    OUTRO = "outro"


class Usuario(Base):
    __tablename__ = "usuarios"

    id = Column(Integer, primary_key=True, index=True)
    nome = Column(String, nullable=False)
    email = Column(String, unique=True, index=True, nullable=False)
    senha_hash = Column(String, nullable=False)
    cpf = Column(String, unique=True, index=True, nullable=False)
    telefone = Column(String)
    tipo = Column(Enum(TipoUsuario), default=TipoUsuario.CLIENTE)
    dataCadastro = Column(DateTime, default=datetime.utcnow)
    nomeDependente = Column(String, nullable=True)
    dataNascDep = Column(Date, nullable=True)

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
    categoria = Column(Enum(CategoriaServico))

    horarios = relationship("HorarioDisponivel", back_populates="servico")


class HorarioDisponivel(Base):
    __tablename__ = "horarios_disponiveis"

    id = Column(Integer, primary_key=True, index=True)
    datahoraInicio = Column(DateTime, nullable=False, index=True)
    vagasTotal = Column(Integer, default=1)
    vagasOcupadas = Column(Integer, default=0)
    local = Column(String)
    observacao = Column(String)
    servico_id = Column(Integer, ForeignKey("servicos.id"), nullable=False)

    servico = relationship("Servico", back_populates="horarios")
    agendamentos = relationship("Agendamento", back_populates="horario")

    def temVagas(self) -> bool:
        return self.vagasOcupadas < self.vagasTotal

    def reservaVagas(self, quantidade: int = 1) -> bool:
        if self.vagasOcupadas + quantidade <= self.vagasTotal:
            self.vagasOcupadas += quantidade
            return True
        return False


class Agendamento(Base):
    __tablename__ = "agendamentos"

    id = Column(Integer, primary_key=True, index=True)
    dataAgendamento = Column(DateTime, default=datetime.utcnow)
    status = Column(Enum(StatusAgendamento), default=StatusAgendamento.PENDENTE)
    dataCancelamento = Column(DateTime, nullable=True)
    compareceu = Column(Boolean, default=False)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)
    horario_id = Column(Integer, ForeignKey("horarios_disponiveis.id"), nullable=False)

    usuario = relationship("Usuario", back_populates="agendamentos")
    horario = relationship("HorarioDisponivel", back_populates="agendamentos")

    def cancelar(self, db_session):
        self.status = StatusAgendamento.CANCELADO
        self.dataCancelamento = datetime.utcnow()
        # libera vaga
        self.horario.vagasOcupadas -= 1
        db_session.commit()

    def confirmarPresenca(self):
        self.compareceu = True
        self.status = StatusAgendamento.REALIZADO


class Notificacao(Base):
    __tablename__ = "notificacoes"

    id = Column(Integer, primary_key=True, index=True)
    titulo = Column(String, nullable=False)
    mensagem = Column(String)
    dataEnvio = Column(DateTime, default=datetime.utcnow)
    lida = Column(Boolean, default=False)
    tipo = Column(String)
    usuario_id = Column(Integer, ForeignKey("usuarios.id"), nullable=False)

    usuario = relationship("Usuario", back_populates="notificacoes")

    def marcarComoLida(self):
        self.lida = True