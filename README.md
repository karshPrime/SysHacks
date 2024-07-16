# System Hacks
Repository of handy command line scripts designed to simplify common tasks and
enhance terminal experience. Each script in this repository is designed to solve
a very specific task, aimubg to make command line sessions more efficient and
enjoyable. 


<details>
<summary>battery_cap.sh</summary>
Limit laptop battery from overcharging. Define maximum charge limit within the 
script and if the model's supported, the script will enable systemd service to 
limit charging over your specified limit.

</details>


<details>
<summary>colors.sh</summary>
Displays all terminal colors along with their escape character codes. Offers a
visual representation of various color combinations for customisation.

![physicalModel](/screenshots/colors.png)
</details>


<details>
<summary>copy_code.sh</summary>
Copy all code of a specified type to clipboard. Would be extremely helpful when
trying to share code where uploading files is not convenient/possible.

![physicalModel](/screenshots/copy_code.png)
</details>


<details>
<summary>cddev.sh</summary>
More convenient way to edit common dev files from within any subdirectory 
within the project. For example edit main file from anywhere within the project
filestructure.

![physicalModel](/screenshots/cddev.png)
</details>


<details>
<summary>gomake.sh</summary>
More robust go build command, to compile program for multiple architectures in
./bin rather than in root project dir.

![physicalModel](/screenshots/gomake.png)
</details>


<details>
<summary>Makefiles/</summary>
Directory consisting of general makefile templates that should be sufficient for
most purposes. 

</details>


<details>
<summary>periodic.sh</summary>
Displays the Periodic Table with color coding for different groups. Provides a
visually appealing representation of chemical elements organised by their atomic
numbers and properties.

![physicalModel](/screenshots/periodic.png)
</details>


<details>
<summary>project_initialise.sh</summary>
Automates project setup tasks, including directory creation, Git initialisation,
README file generation, language-specific setup, and .gitignore configuration.
Simplifies the process of starting new software projects.

![physicalModel](/screenshots/project_initialise.png)
</details>


<details>
<summary>refresh.sh</summary>
Clears cache and displays memory usage before and after cache clearing. Provides
a quick overview of system memory usage, including total, used, free, shared,
and buffer/cache memory.


![physicalModel](/screenshots/refresh.png)
</details>


<details>
<summary>rename.sh</summary>
Mass rename files using a text editor. Super handy with vim motions and macros.
Also supports file conversion via `ffmpeg`. Rename a file with new extension,
and the script will convert it as well.

![physicalModel](/screenshots/rename.png)
</details>


<details>
<summary>resistor.c</summary>
Gives resistance values for band colors. If provided with specific bands (e.g.,
blue red green gold), it will output the corresponding resistance value. With no
parameters, it will display a table of all band colors and their corresponding
values.

![physicalModel](/screenshots/resistor.png)
</details>


<details>
<summary>rmsymlink.sh</summary>
Script designed to remove symbolic links and their target files. It ensures a
clean deletion process, first deleting the symbolic link itself and then, if
applicable, the target file it points to. 

![physicalModel](/screenshots/rmsymlink.png)
</details>


<details>
<summary>testing.sh</summary>
Script to prevent having 100s of testing temporary directories within Project
or even ~. This script works with project_initialise to create a testX dir
within /tmp/ for temporary usecase.

![physicalModel](/screenshots/testing.png)
</details>


<details>
<summary>todo.sh</summary>
Maintains an organised library of todo files at a specified location. Opens a
todo file associated with the current project or directory in the default
editor.

![physicalModel](/screenshots/todo.png)
</details>


<details>
<summary>trash.sh</summary>
Moves files and directories to the system's trash directory instead of
permanently deleting them. Mimics the behavior of graphical environment trash
systems from the terminal, providing an opportunity to restore or permanently
delete files later.

![physicalModel](/screenshots/trash.png)
</details>


<details>
<summary>vimacro.sh</summary>
Bring the magic of vim macros to shell.

![physicalModel](/screenshots/vimacro.png)
</details>

