from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import settings
from .routers import health, nudge, adapt, predict, message, confidence, story
from .middleware.auth import AuthMiddleware


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: initialize Firebase Admin SDK if needed
    # import firebase_admin
    # cred = firebase_admin.credentials.Certificate(settings.firebase_credentials_path)
    # firebase_admin.initialize_app(cred)
    yield
    # Shutdown cleanup


app = FastAPI(
    title="Mission Invest AI Service",
    description="AI microservice for nudges, predictions, and motivational messages",
    version="1.0.0",
    lifespan=lifespan,
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Auth middleware — uncomment after Firebase setup
# app.add_middleware(AuthMiddleware)

# Routers
app.include_router(health.router, tags=["Health"])
app.include_router(nudge.router, prefix="/ai", tags=["AI"])
app.include_router(adapt.router, prefix="/ai", tags=["AI"])
app.include_router(predict.router, prefix="/ai", tags=["AI"])
app.include_router(message.router, prefix="/ai", tags=["AI"])
app.include_router(confidence.router, prefix="/ai", tags=["AI"])
app.include_router(story.router, prefix="/ai", tags=["AI"])
