from sqlalchemy import Column, String, Integer, Text, Boolean, Float, ForeignKey
from sqlalchemy.orm import relationship

from server.src.models.entity import Entity


class Game(Entity):
    # TODO: slight simplification: developer and publisher must be ForeignKeys I think

    __tablename__ = "games"

    title = Column(String, index=True, nullable=False)
    release_date = Column(Integer, index=True)
    developer = Column(String, index=True, nullable=False)
    publisher = Column(String, index=True, nullable=False)
    short_description = Column(Text, nullable=False)
    long_description = Column(Text, nullable=False)
    price = Column(Float, default=0.0, nullable=False)
    directory = Column(String, nullable=False)

    builds = relationship("Build", backref="game")

    author_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), index=True, nullable=False)
    author = relationship("User", back_populates="games")

    status_id = Column(Integer, ForeignKey("game_statuses.id", ondelete="RESTRICT"), index=True, nullable=False)
    status = relationship("GameStatus", back_populates="games")
