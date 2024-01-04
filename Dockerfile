# Use Alpine Linux as the base image
FROM alpine:latest as builder

ARG APPDIR='/getstatus'
ARG APPPATH='/getstatus/getstatus'

# Copy the local binary to the container
COPY ./bin/getstatus-linux-amd64 ${APPDIR}/
COPY ./bin/getstatus-linux-arm64 ${APPDIR}/

RUN if [ "$(uname -a | awk '{ print $(NF-1) }')" = "x86_64" ]; then \
      mv ${APPDIR}/getstatus-linux-amd64 ${APPPATH}; \
    elif [ "$(uname -a | awk '{ print $(NF-1) }')" = "aarch64" ]; then \
      cp ${APPDIR}/getstatus-linux-arm64 ${APPPATH}; \
    else \
      echo "Unsupported platform: $(uname -a)"; \
      exit 1; \
    fi

# Make the binary executable
RUN chmod +x ${APPPATH}

# Run from safe(r) container
FROM gcr.io/distroless/static-debian12
COPY --from=builder /getstatus /getstatus

# Switch to the non-root user
USER nonroot

# set the working directory in the container
WORKDIR /getstatus

# Command to run when the container starts
CMD ["./getstatus"]
