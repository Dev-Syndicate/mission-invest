from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    firebase_project_id: str = "mission-invest-dev"
    firebase_credentials_path: str = "./service-account.json"
    gemini_api_key: str = ""
    llm_provider: str = "gemini"
    llm_model: str = "gemini-3.0-flash"
    cors_origins: List[str] = ["http://localhost:3000", "http://localhost:8080"]
    log_level: str = "info"
    port: int = 8000

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
