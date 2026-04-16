from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    firebase_project_id: str = "mission-invest-dev"
    firebase_credentials_path: str = "./service-account.json"
    anthropic_api_key: str = ""
    openai_api_key: str = ""
    llm_provider: str = "anthropic"
    llm_model: str = "claude-sonnet-4-20250514"
    cors_origins: List[str] = ["http://localhost:3000", "http://localhost:8080"]
    log_level: str = "info"
    port: int = 8000

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}


settings = Settings()
