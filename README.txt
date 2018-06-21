System Requirements:
====================

a) Supported Windows Operating Systems:
	Windows Vista
	Windows 7
	Windows 8
	Windows 8.1
	Windows 10

b) Supported Architectures:
	32-bit
	64-bit

c) RAM and Storage Space:
	Minimum 2GB RAM recommended
	Minimum 4GB Storage Space recommended
	

Uninstallating Earlier Version of Osdag:
========================================

1) Go to the location where Osdag was installed and run "Uninstall.exe".

2) Go to "C:\Program Files (x86)" and delete the "Miniconda2" and "wkhtmltopdf" folders.


Installation Steps:
===================

1) Run "Osdag-Windows-x86.exe" and follow the on-screen instructions. (You need to have administrative privileges to install Osdag.)
Note: 
	a) If you already have an earlier version of Osdag installed on your system, please uninstall it before installing the latest version. Please see above section for reference.
	b) If you have problems installing the Osdag setup, try disabling the anti virus during the INSTALLATION. Once Osdag is installed, you can enable it back.

2) In the "Choose Install Location" step, choose the location where you want to install Osdag and click "Next". 
Note: You can change the default location but if you install Osdag in a location where administrative privileges are required, you will need adminstrative privileges to run Osdag every single time.

3) You may choose to create a shortcut for Osdag in the Start Menu folder and click "Next".

4) The installer will now install Miniconda, wkhtmltopdf, python dependecies and Osdag in sequence (This step might take a few minutes depending on your system).

5) Once the installation is done, you can click "Finish" to close the setup.


Running Osdag:
==============

Once the installation is complete, you can run Osdag using any of the following options:
	a) Osdag desktop shortcut
	b) Start menu shortcut
	c) Osdag shortcut in the Osdag installation directory

Important Notes:
=================

1) You need "Microsoft Visual C++ 2015 Redistributable (x86)" to run Osdag. (You need the 32bit x86 version even if you have 64bit Windows OS.)
	a) To check if you already have this installed, go to 'Control Panel -> Programs -> Programs and Features' and check in the list of programs.
	b) If you don't have it installed, go to 'https://www.microsoft.com/en-in/download/details.aspx?id=48145', download 'vc_redist.x86.exe' and install it.

2) When running Osdag for the first time, it might take a few minutes (depending on your system) for Osdag to open.

3) If you have installed Osdag in a location where administrative privileges are required, you have to right click on any of the above shortcuts and click "Run as administrator" to run Osdag.

4) If you are installing Osdag through a Windows account which is not an administrator, Osdag desktop and start menu shortcuts might not be created. You can copy the shortcut from the folder where you have installed Osdag and paste it where ever you like.
