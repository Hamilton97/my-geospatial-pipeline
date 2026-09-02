# ==========================================
# STAGE 1: Conda Builder
# ==========================================
FROM mambaorg/micromamba:latest AS builder

# Micromamba container defaults to non-root mambauser
COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /tmp/environment.yml

# Install packages into the base conda environment and clean cache
RUN micromamba install -y -n base -f /tmp/environment.yml && \
    micromamba clean --all --yes

    
# ==========================================
# STAGE 2: Production Runtime
# ==========================================
FROM mambaorg/micromamba:latest AS runner
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    nano \
    && rm -rf /var/lib/apt/lists/*
USER $MAMBA_USER

USER root
WORKDIR /app

# Copy the pre-built conda environment from builder
COPY --from=builder /opt/conda /opt/conda

# Ensure conda binaries (python, gdal, etc.) are default on PATH
ENV PATH="/opt/conda/bin:$PATH" \
    PYTHONUNBUFFERED=1

# Copy source code
COPY src/ /app/src/

# Run as a non-root user
USER $MAMBA_USER
