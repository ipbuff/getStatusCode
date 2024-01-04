BINARY_DIR = bin
BINARY_NAME = getstatus
RUN_ARCH = linux/amd64

# Go parameters
GOCMD = go
GOBUILD = $(GOCMD) build
GOTEST = $(GOCMD) test
GOCLEAN = $(GOCMD) clean
CGO_ENABLED = 0

# Build flags and arguments
LDFLAGS = -ldflags="-s -w"
GCFLAGS = -gcflags="-m -l"
MODFLAGS = -mod=readonly
TRIMPATH = -trimpath

# Cross-compilation target architectures
TARGETS = \
	linux/arm64 \
	linux/amd64

.PHONY: all

all: build

# Build for all the configured target architectures (TARGETS)
build: $(TARGETS)

$(TARGETS):
	GOOS=$(word 1, $(subst /, ,$@)) GOARCH=$(word 2, $(subst /, ,$@)) CGO_ENABLED=$(CGO_ENABLED)\
		$(GOBUILD) $(LDFLAGS) $(GCFLAGS) $(MODFLAGS) $(TRIMPATH) \
		-o $(BINARY_DIR)/$(BINARY_NAME)-$(word 1, $(subst /, ,$@))-$(word 2, $(subst /, ,$@))

# Clean builds
clean:
	rm -f $(BINARY_DIR)/$(BINARY_NAME)-*

# Build and run
run: build
	./$(BINARY_DIR)/$(BINARY_NAME)-$(word 1, $(subst /, ,$(RUN_ARCH)))-$(word 2, $(subst /, ,$(RUN_ARCH)))

# Includes race testing
test:
	$(GOTEST) -v

