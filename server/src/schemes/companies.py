from pydantic import BaseModel


class CompanyApprovingScheme(BaseModel):
    is_approved: bool


class CompanyCreateScheme(BaseModel):
    juridical_name: str


class CompanyDBScheme(CompanyCreateScheme):
    class Config:
        orm_mode = True