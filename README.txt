CSF Volumetry GUI
>This MATLAB application, including a graphical user interface (GUI), is developed for segmenting and analyzing cerebrospinal fluid (CSF) volumes from NIFTI files. 
>The GUI allows users to select a NIFTI file, adjust parameters, visualize the middle slice, and results of all segmentation steps.

Installation:
1. Ensure that you have MATLAB installed on your system.
2. Extract the 3D_CISS_segmentation.zip files to your desired location.
3. Add the extracted folder to the MATLAB path. You can do this by using the addpath function in MATLAB or by navigating to the folder and selecting "Add to Path".

Files:
1. CSF_volumetry_gui.m: The main GUI application script.
2. CSF_volumetry.m: The function that performs the CSF volumetry analysis.Can be used without GUI.
3. Additional files and dependencies required for the CSF_volumetry function.

Usage:
1. Run the GUI: Open MATLAB and navigate to the directory containing CSF_volumetry_gui.m. Run the script by typing CSF_volumetry_gui in the MATLAB command window.
2. Select Parameters: Adjust the parameters for plotting results, median filtering, alpha, alpha2, and percentile.
3. Select NIFTI File: Click on "Select File & Run" to choose a NIFTI file for analysis.
4. View Middle Slice: The middle slice of the selected NIFTI file will be displayed in the GUI.
5. Run Analysis: The CSF volumetry analysis will be executed with the selected parameters. A message box will appear upon successful completion.

Parameters:
1. Plot Results: Choose whether to plot results (Yes/No).
2. Median Filter: Apply a median filter to the data (Yes/No).
3. Alpha: Set the alpha parameter (default: 0.02).
4. Alpha2: Set the alpha2 parameter (default: 0.025).
5. Percentile: Set the percentile parameter (default: 97.5).

Example how to run the GUI and perform a CSF volumetry analysis:

1. Open MATLAB.
2. Ensure that the current directory is set to the location where the CSF_volumetry_gui.m script is located.
3. Type CSF_volumetry_gui and press Enter.
4. In the GUI, set the desired parameters.
5. Click "Select File & Run" and choose a NIFTI file.
6. View the middle slice of the selected file.
7. The analysis will run, and a message box will confirm completion.

Dependencies:
1. This application requires the following MATLAB toolboxes:

	1.1 Image Processing Toolbox
	1.2 Statistics and Machine Learning Toolbox

Contact
For questions or issues, please contact Ryszard S. Gomolka, PhD at ryszard.gomolka@sund.ku.dk.

