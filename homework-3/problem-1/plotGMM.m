for i = 1:nc
    subplot(3, 2, i)
    scatter(data(:, 1), data(:, 2), '.r')
    hold on
    
    currMu = avgComps{i}{1};
    currCov = avgComps{i}{2};
    currWgt = avgComps{i}{3};
    tempMu = [];
    tempCov = zeros(2, 2, i);
    tempWgt = [];
    
    for n = 1:i
        tempMu  = [tempMu;currMu{n}];
        tempCov(:, :, n) = currCov{n};
        tempWgt = [tempWgt, currWgt{n}];
    end    
    tempMu;
    newGM = gmdistribution(tempMu, tempCov, tempWgt);
    gmPDF_new = @(x, y) reshape(pdf(newGM, [x(:), y(:)]), size(x));
    fcontour(gmPDF_new, 'LineWidth', 1, 'LineStyle', '-')
    axis([-1 3 -1 3])
    %fcontour(gmPDF)
    hold off
end