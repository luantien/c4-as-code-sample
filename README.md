# c4-as-code-sample

A simple C4 Diagram As Code sample that use Structurizr DSL with Visual Studio Code for visualization diagrams

You can use `Struturizr` plugin in `VSCode` and `structurizr/lite` docker image to run this sample. And create `.env` from `.env.sample`
```bash
docker run -it --rm -p 8080:8080 -v {YOUR_ROOT_WORKSPACE_DIR}:/usr/local/structurizr --env-file .env structurizr/lite
```
The set contains these diagrams:
- Level 1 – System Context Diagram
- Level 2 – Container Diagram
- Level 3 – Component Diagram
- Deployment Diagram
- Cloud Architecture Diagram

Ref: https://github.com/structurizr/dsl/blob/master/docs/language-reference.md