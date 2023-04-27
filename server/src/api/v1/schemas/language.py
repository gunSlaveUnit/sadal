from pydantic import BaseModel

from server.src.api.v1.schemas.entity import EntityDBSchema


class LanguageCreateSchema(BaseModel):
    title: str


class LanguageDBSchema(LanguageCreateSchema, EntityDBSchema):
    class Config:
        orm_mode = True
