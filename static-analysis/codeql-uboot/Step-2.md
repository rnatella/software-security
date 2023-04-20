## Step 2: Setup your environment

We will use the CodeQL extension for Visual Studio Code. You will take advantage of IDE features like auto-complete, contextual help and jump-to-definition.

Don't worry, you'll do this setup only once, and you'll be able to use it for future CodeQL development.

### :keyboard: Activity: Set up
1. Install the [Visual Studio Code IDE](https://code.visualstudio.com/).
1. Go to the [CodeQL starter workspace repository](https://github.com/github/vscode-codeql-starter/), and follow the instructions in that repository's README. When you are done, you should have the CodeQL extension installed and the `vscode-codeql-starter` workspace open in Visual Studio Code.
1. Download and unzip [this U-Boot CodeQL database](https://github.com/github/securitylab/releases/download/u-boot-codeql-database/u-boot_u-boot_cpp-srcVersion_d0d07ba86afc8074d79e436b1ba4478fa0f0c1b5-dist_odasa-2019-07-25-linux64.zip), which corresponds to revision [`d0d07ba`](https://github.com/u-boot/u-boot/tree/d0d07ba86afc8074d79e436b1ba4478fa0f0c1b5).
1. Import the database into Visual Studio Code ([see documentation](https://codeql.github.com/docs/codeql-for-visual-studio-code/analyzing-your-projects/#choosing-a-database)). This is the database that we'll be running queries on for the duration of this course.
1. Clone this course repository on your local machine.
1. Add this folder to your Visual Studio Code starter workspace, by navigating to `File -> Add Folder to Workspace...`. If you open this folder you should see several files in there, including `qlpack.yml`.

