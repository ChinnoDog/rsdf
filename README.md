# Rapid Solution Delivery Framework
This is a template project containing common code used for build and delivery of software to Nasuni customers. It is delivered as a group of makefiles defining optional targets for you to select from.

# Getting Started
1. Rename this file so you can create your own `README.md`  
   `git mv README.md README_TEMPLATE.md`
1. Create your application's makefile at `makefile.d/myapp.mk`
1. Add targets below as dependencies of the `all` target and set related variables in `myapp.mk`
1. Create the `install` target that installs your application.

# Debug Configuration
Most of the time you will want to execute commands using the debug configuration. This provides extra tools for resolving problems in the code. To do this simply `export DEBUG=true` before running make. When you are ready to create production quality artifacts then `export DEBUG=false` or simply `unset DEBUG` and run make again.

# Features
Targets and variables to use each feature.

## Documentation
- `%.pdf` target: PDF versions of all markdown files can be generated. Simply depend on the name of the file with a .pdf extension. E.g. `README.pdf`.

## python
- `.venv` target: build a python virtual environment.
- `python_packages` variable: Add any project-specific packages to this variable

## Linux container
- `container` target: Builds a container with docker. The container name is the name of the project. It will either be tagged `latest` or `debug` depending on the debug setting. The `install` target must be defined for this to work.
- `container.tar.gz` target: Export the container to an archive.
- `base_image` variable: Use this variable to set the base image fo your container
- `container-upload` target: This will create a repository on AWS Elastic Container Registry (ECR) and upload your image. Your aws client must be configured for this to work and you must have permission to ECR. The registry path will be determined by your account and region. This target is most useful for manually uploading releases but you can also use it as a dependency if you need to download the image from another location during testing.

## certificates
This produces a private certificate intrastructure pariticularly useful with SSL.
- `host-<hostname>.crt` target: Create a certificate for your test host. `test-ca.crt` will be generated for you automatically. Apply the requested certificate to your test system and add `test-ca.crt` to the trusted client trust store to be able to validate it..