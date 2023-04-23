from sqlalchemy import Column, Integer, ForeignKey, String

from server.src.core.models.entity import Entity


class Build(Entity):
    __tablename__ = "builds"

    directory = Column(String, nullable=False)
    call = Column(String, nullable=False)
    params = Column(String)

    game_id = Column(Integer, ForeignKey("games.id", ondelete="CASCADE"), index=True, nullable=False)
    platform_id = Column(Integer, ForeignKey("platforms.id", ondelete="RESTRICT"), index=True, nullable=False)