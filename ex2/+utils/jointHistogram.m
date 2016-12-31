function [ countJoint, count1, count2 ] = jointHistogram( image1, bins1, image2, bins2 )

    [~, ind1] = histc(image1(:),[bins1 Inf]);
    [~, ind2] = histc(image2(:),[bins2 Inf]);

    valid = ind1>0 & ind2>0 & ind1<length(bins1) & ind2<length(bins2);
    countJoint = accumarray({ind1(valid),ind2(valid)},1);
    count1 = accumarray({ind1(valid)},1);
    count2 = accumarray({ind2(valid)},1);
end

