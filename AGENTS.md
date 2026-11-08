# Project instructions

This project uses Flutter. Follow these instructions for every task in this repository.

## Project constitution

- Always consult the project constitution before starting a task, and follow its architecture, conventions, and development rules.
- The constitution is `docs/CONSTITUTION.md`. Read the relevant focused guide linked from it before changing that area.
- Project documentation lives in `docs/` and must be written in English. This project does not use Spec Kit.
- Bible, confession, catechism, creed, and other included historical-document reading, along with basic search, must work offline using one bundled SQLite database file, without authentication.
- If the constitution is missing, report that it is missing. Do not invent its contents or claim to have consulted it.

## Architecture requirements

- Apply SOLID across layers, especially dependency inversion and interface segregation. Use constructor-injected, focused interfaces rather than concrete infrastructure dependencies.
- Every implemented data feature has a local repository interface and implementation. Add a separate remote repository interface and implementation only when remote access is needed.
- Encapsulate external infrastructure packages behind application-owned interfaces. For HTTP, remote repositories depend on `HttpClient`; `DioHttpClient` implements it and receives `Dio` through constructor injection. Only the adapter calls Dio directly. Apply the same boundary to SQLite and other storage packages.

## Working preferences

- Read only the files necessary for the task. Stop searching once you have the information you need. Do not explore unrelated files or directories.
- Prefer targeted text searches and relevant excerpts over reading entire files or producing large outputs.
- Do not run scripts, tests, or checks unless the user requests them or they are necessary to complete the authorized task.
- For every command you run, always redirect both stdout and stderr to a temporary file. Never let raw command output enter the conversation context. This applies to all commands, including searches, file reads, scripts, tests, and checks, regardless of their expected output size.
- Check only the exit code first. When needed, extract only the smallest relevant excerpt from the saved output. Never dump the entire output file into context. Avoid verbose options.
- Avoid repeating searches and reads. Batch independent operations when doing so reduces tool calls without adding noise.
- Keep progress updates and final summaries concise. Record important decisions and pending items so completed work does not need to be revisited.
