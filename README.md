# writing

### A writing environment that make using Manuskript easier. Also, there's other stuff.

Run `init.sh` to install everything. This will install:
 - Manuskript
 - Pandoc
 - LanguageTool
 - Prosegrinder pandoc templates


You can activate the environment in the terminal with the command `writing`. This will let you use the following commands:
- **manuskript** or **msk** : Open Manuskript.
- **atmo** : Choose the background image for the "atmosphere" full-screen theme in Manuskript.
- **compile** : Compile a Manuskript project to epub or docx (using the Shunn manuscript format).
- **upload** and **download** : Use git to back up your writing to a remote server.

You can make the following changes:
 - `.writing/frontmatter.yml` : Your author details, for your compiled projects.
 - `backgrounds` : Copy any background images for your atmo theme (must be jpegs)
