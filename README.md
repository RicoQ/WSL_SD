<a href="https://github.com/RicoQ/WSL_SD">
    <img src=".Gnu-bash-logo.svg.png" alt="Bash logo" title="BASH" align="center" height="100" /> 
</a>


# Automatic Wsl Configuration and Stable Diffuion Webui Installation  

This project is for my use ONLY. It has no value to anyone else... But if it can help you, feel free to use.

Some changes to the code might be needed for it to work for you... 
I've made it so it will work on my PC, with my current setup - "WSL debian distribution".

I do not plan on making this script adaptable for others... But I might one day, will see... 

**NOTE**: 
- For now the Password Input is not needed... So you can write anything in the input field. The "password" variable is not being used anywhere... It is there in case I need it later.
- When you install the WSL Distribution, the first time it runs you must enter a UserName and Password. Once this is done, 2 input field appears on the main.ps1 window.
- You need to input the same UserName that you entered earlier... and as a said above, the password is not needed yet, so you can put in anything in this field.

## Requirements
- Here is a ref worth looking at --> https://learn.microsoft.com/en-us/windows/wsl/install
- You need windows and Wsl working properly
- You also need admin rights on your PC
- You also need to disable a few restrictions within PowerShell.  
    - For more details:  https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-7.3
    - Run PowerShell as Administrator 
```
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
```

## How it works.
- Enter a Distribution Name 
    - (To help you choose you can use the "Show List")
- "Install WSL" button will install the required tools for WSL and Install the Distibution you entered above
    - (Once done you need to do "exit" in the terminal to close the window)
- Enter the Username 
    - (must be the same that you used when installing the Distribution)
- Enter the User Password 
    - (Right now, this does nothing but you still need to enter something)
- "Copy Config Files" copies the needed config files where they need to go. 
    - (Those config files are for my PC and might need to be changed according to your spesifications)
- "Install SD" configues a few things I find useful on the WSL and installs Stable Diffusion webui 
    - (Right now this button only launches an instance of your wsl distribution)
    - You will need to Run a few commands to install everything, I ran into a few erros when runing a script bash from PowerShell.
    - To Workaround this I wrote one Script that does everything powershell was suposed to do... (I'll fix that one day)  
    - Type in the 2 following commands into the wsl terminal.

```
sudo chmod +x ./Prep.sh
bash ./Prep.sh
```

## To launch SD 
- There a 4 arguments possible:
    - no option             Simply run Stable Diffusion
	- --update, -U          Updates everything (i.e., SD, all extensions, and the Conda Environment)
	- --lama, -L            Updates only the Lama Cleaner app and starts it (not used with -R, -U)
	- --reinstall, -R       Reinstall Torch & Xformer (and also starts SD)
    - --help, -H, -h        Shows this help text"

```
bash ~/Start_SD.sh 
```

## Contributing

* [DevOps Engineer] = Eric QUERCIA
    * https://github.com/RicoQ
    * https://www.linkedin.com/in/eric-quercia/

## License
TBD.