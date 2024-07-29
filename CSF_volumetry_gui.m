function CSF_volumetry_gui()
    % Create the main figure window
    hFig = figure('Name', 'SEGMENT CSF', 'Position', [100, 100, 800, 300], 'MenuBar', 'none', 'NumberTitle', 'off','Resize','off');

    % Create uicontrols for the plt option
    uicontrol('Style', 'text', 'Position', [20, 240, 100, 20], 'String', 'Plot Results:');
    hPlt = uicontrol('Style', 'popupmenu', 'Position', [130, 240, 100, 20], 'String', {'No', 'Yes'}, 'Value', 1);

    % Create uicontrols for the mfilt option
    uicontrol('Style', 'text', 'Position', [20, 200, 100, 20], 'String', 'Median Filter:');
    hMfilt = uicontrol('Style', 'popupmenu', 'Position', [130, 200, 100, 20], 'String', {'No', 'Yes'}, 'Value', 1);

    % Create uicontrols for the alpha parameter
    uicontrol('Style', 'text', 'Position', [20, 160, 100, 20], 'String', 'Alpha:');
    hAlpha = uicontrol('Style', 'edit', 'Position', [130, 160, 100, 20], 'String', '0.02');

    % Create uicontrols for the alpha2 parameter
    uicontrol('Style', 'text', 'Position', [20, 120, 100, 20], 'String', 'Alpha2:');
    hAlpha2 = uicontrol('Style', 'edit', 'Position', [130, 120, 100, 20], 'String', '0.025');

    % Create uicontrols for the percentile parameter
    uicontrol('Style', 'text', 'Position', [20, 80, 100, 20], 'String', 'Percentile:');
    hPercentile = uicontrol('Style', 'edit', 'Position', [130, 80, 100, 20], 'String', '97.5');

    % Create a button to select the NIFTI file and run the SEGMENT CSF function
    hSelectAndRun = uicontrol('Style', 'pushbutton', 'Position', [150, 20, 100, 40], 'String', 'Select File & Run', 'Callback', @selectAndRun);

    % Variable to store the selected file path
    niftiFile = '';

    function selectAndRun(~, ~)
        % Prompt user to select a NIFTI file
        [filename, pathname] = uigetfile({'*.nii;*.nii.gz', 'NIFTI Files (*.nii, *.nii.gz)'}, 'Select a NIFTI file');
        if isequal(filename, 0)
            errordlg('User canceled file selection', 'File Error');
        else
            niftiFile = fullfile(pathname, filename);

            % Display the middle slice of the selected file
            try
                if endsWith(niftiFile, '.nii.gz')
                    gunzip(niftiFile);
                    unzippedFile = strrep(niftiFile, '.nii.gz', '.nii');
                    image = double(niftiread(unzippedFile));  % Use double to ensure it matches the desired data type
                    delete(unzippedFile);  % Clean up the unzipped file
                else
                    image = double(niftiread(niftiFile));  % Use double to ensure it matches the desired data type
                end
                midslice = image(:, :, round(size(image, 3) / 2));
                hAxes = axes('Parent', hFig, 'Position', [0.4, 0.2, 0.5, 0.7]);
                imshow(midslice, [], 'Parent', hAxes);
                title(hAxes, 'Middle Slice');
            catch
                errordlg('Error reading NIFTI file. Please check the file format.', 'File Error');
                niftiFile = '';  % Reset the file path
                if exist('hAxes', 'var')
                    delete(hAxes);
                end
            end

            % Get values from the UI controls
            plt = get(hPlt, 'Value') - 1;  % Convert to 0/1
            mfilt = get(hMfilt, 'Value') - 1;  % Convert to 0/1
            alpha = str2double(get(hAlpha, 'String'));
            alpha2 = str2double(get(hAlpha2, 'String'));
            percentile = str2double(get(hPercentile, 'String'));

            % Validate input values
            if isnan(alpha) || isnan(alpha2) || isnan(percentile)
                errordlg('Invalid input for parameters. Please enter valid numbers.', 'Input Error');
                return;
            end

            % Create params struct
            params = struct('alpha', alpha, 'alpha2', alpha2, 'percentile', percentile);

            % Call the SEGMENT CSF function
            try
                CSF_volumetry(pathname, filename, plt, mfilt, params);
                close(hFig); %close GUI after execution
                msgbox('CSF volumetry completed successfully!', 'Success');
            catch ME
                errordlg(['An error occurred: ', ME.message], 'Error');
            end
        end
    end
end