function ICV_create_folder(folder_name)
    if ~exist(folder_name, 'dir')
        mkdir(folder_name);
    end
end