type = 'forefinger';
session = 1;
basedir1 = 'data/subject';
out_dir1 = 'feature/subject';
downsample_factor = 0.1980/0.4235; %for getting [70x100] depth map for matching
basedir2 = ['/session' num2str(session) '/' type '/set'];
for subjectID = 1:2
    for setID = 1:2
        disp([num2str(subjectID) ',' num2str(setID) '...'])
        load([basedir1 num2str(subjectID) basedir2 num2str(setID) '/surfNormal.mat']);
        N = reshape(surfNormal,212,149,3);
        N = imresize(N, downsample_factor);
        N2 = permute(N,[2 1 3]);
        
        %% Surface Normal Distance Computation
        pair = [1 9; 2 8;3 7;4 6];
        sz = [3 3]; 
        snd = false(size(N2,1),size(N2,2),size(pair,1));
        for i = 1+1:size(N2,1)-1
            for j = 1+1:size(N2,2)-1
                regionx = N2(i-1:i+1,j-1:j+1,1);
                regiony = N2(i-1:i+1,j-1:j+1,2);
                regionz = N2(i-1:i+1,j-1:j+1,3);
                for pair_idx = 1:size(pair,1)
                    [y10,x10] = ind2sub(sz,pair(pair_idx,1));
                    [y20,x20] = ind2sub(sz,pair(pair_idx,2));

                    x11 = x10 + regionx(pair(pair_idx,1));
                    y11 = y10 + regiony(pair(pair_idx,1));
                    z11 = 0 + regionz(pair(pair_idx,1));
                    x21 = x20 + regionx(pair(pair_idx,2));
                    y21 = y20 + regiony(pair(pair_idx,2));
                    z21 = 0 + regionz(pair(pair_idx,2));

                    d0 = sqrt((x10-x20)^2+(y10-y20)^2+0^2);
                    d1 = sqrt((x11-x21)^2+(y11-y21)^2+(z11-z21)^2);

                    if(d1<d0)
                        snd(i,j,pair_idx) = 1;
                    end
                end
            end
        end
        
        %% Surface Normal Distance Computation (Fast Implementation)
        %{
        temp = imfilter(N2,[-1 0 0; 0 0 0; 0 0 1]);
        sndf(:,:,1) = (temp(:,:,1)+2).^2+(temp(:,:,2)+2).^2+(temp(:,:,3)).^2 < 8;
        temp = imfilter(N2,[0 0 0; -1 0 1; 0 0 0]);
        sndf(:,:,2) = (temp(:,:,1)+2).^2+(temp(:,:,2)).^2+(temp(:,:,3)).^2 < 4;
        temp = imfilter(N2,[0 0 1; 0 0 0; -1 0 0]);
        sndf(:,:,3) = (temp(:,:,1)+2).^2+(temp(:,:,2)-2).^2+(temp(:,:,3)).^2 < 8;
        temp = imfilter(N2,[0 -1 0; 0 0 0; 0 1 0]);
        sndf(:,:,4) = (temp(:,:,1)).^2+(temp(:,:,2)+2).^2+(temp(:,:,3)).^2 < 4;
        %}
        
        mkdir([out_dir1 num2str(subjectID) basedir2 num2str(setID)]);
        save([out_dir1 num2str(subjectID) basedir2 num2str(setID) '/snd.mat'],'snd')
        imwrite(snd(:,:,1),[out_dir1 num2str(subjectID) basedir2 num2str(setID) '/snd1.bmp'])
        imwrite(snd(:,:,2),[out_dir1 num2str(subjectID) basedir2 num2str(setID) '/snd2.bmp'])
        imwrite(snd(:,:,3),[out_dir1 num2str(subjectID) basedir2 num2str(setID) '/snd3.bmp'])
        imwrite(snd(:,:,4),[out_dir1 num2str(subjectID) basedir2 num2str(setID) '/snd4.bmp'])
    end
end