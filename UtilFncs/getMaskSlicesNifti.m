function [mask_slices_n, mask_height, mask_width, mask_slices, voxel_dims, slices_data] = getMaskSlicesNifti(mask_file)
    mask = [];
    for retry=1:5
        try
            mask = load_nii(mask_file);
            mask_slices_n = mask.hdr.dime.dim(4);
            mask_height = mask.hdr.dime.dim(3);
            mask_width = mask.hdr.dime.dim(2);
            mask_slices_t = reshape(mask.img, [], mask_slices_n);
            voxel_dims = [mask.hdr.dime.pixdim(2), mask.hdr.dime.pixdim(3), mask.hdr.dime.pixdim(4)];
            break;
        catch
            fprintf('File reading failed for : %s \nSleeping 5s before retrying...', mask_file);
            try
                clear mask;
            end
            pause(5);
            if retry < 5
                continue;
            else
                fprintf('File reading failed and connot recover. ')
                exit
            end
        end
    end
    mask_slices = mask_slices_t > 0.5;
    slices_data = mask_slices_t;
    clear mask;
end
