clear;
close all;
True = imread('TrumanEatsLunchII-1.jpg');
watermark = imread('smiley.jpg');

step = 16;


watermark = flipud(watermark);

[clusters,centers] = kmeans(True);
%making new block vectors by replacing the blocks with their closest
%centriod
Xp = zeros(256,1024);
for i = 1:20
    indexs = clusters{i};
    for j = 1:length(indexs)
        Xp(:,indexs(j)) = centers(:,i);
    end
end

%making the reconstructed image by reversing the block process
reconstructed = uint8(zeros(size(True)));

k = 1;
for i = 1:step:512
    for j = 1:step:512
        block = Xp(:,k);
        block = reshape(block,16,16);
        reconstructed(i:i+step-1,j:j+step-1) = block;
        k = k+1;
    end
end
figure;
imshow(reconstructed);

difference = abs(True - reconstructed);
figure;
imshow(difference);

%doing the same thing we just did but with the difference image

[clusters,centers] = kmeans(difference);
%making new block vectors by replacing the blocks with their closest
%centriod
Xpp = zeros(256,1024);
for i = 1:20
    indexs = clusters{i};
    for j = 1:length(indexs)
        Xpp(:,indexs(j)) = centers(:,i);
    end
end

%making the reconstructed image by reversing the block process
reconstructed_diff = uint8(zeros(size(True)));

k = 1;
for i = 1:step:512
    for j = 1:step:512
        block = Xpp(:,k);
        block = reshape(block,16,16);
        reconstructed_diff(i:i+step-1,j:j+step-1) = block;
        k = k+1;
    end
end

final = reconstructed+reconstructed_diff;
figure;
imshow(final);


%Step 5 watermark prep
W = imbinarize(watermark);


%creating indexes matrix
[clusters1,centers1] = kmeans(True);
Y0 = 1:1024;
Y0 = reshape(Y0,32,32)';
Y = zeros(32,32);
for i = 1:20
    values = clusters1{i};
    for j = 1:length(values)
        [x,y] = find(Y0==values(j));
        Y(x,y) = i;
    end
end

%variance matrix
V = zeros(32,32);
for i = 2:31
    for j = 2:31
        %3x3 neighborhood
        V(i,j) = var([Y(i,j) Y(i-1,j-1) Y(i-1,j) Y(i-1,j+1) Y(i,j-1) Y(i,j+1) Y(i+1,j-1) Y(i+1,j) Y(i+1,j+1)]);
    end
end
for j = 2:31
    %top and bottom rows
    V(1,j) = var([Y(1,j-1) Y(1,j) Y(1,j+1) Y(2,j-1) Y(2,j) Y(2,j+1)]);
    V(end,j) = var([Y(end,j-1) Y(end,j) Y(end,j+1) Y(end-1,j-1) Y(end-1,j) Y(end-1,j+1)]);
end
for i = 2:31
    %left and right columns
    V(i,1) = var([Y(i-1,1) Y(i,1) Y(i+1,1) Y(i-1,2) Y(i,2) Y(i+1,2)]);
    V(i,end) = var([Y(i-1,end) Y(i,end) Y(i+1,end) Y(i-1,end-1) Y(i,end-1) Y(i+1,end-1)]);
end
%corners
V(1,1) = var([Y(1,1) Y(1,2) Y(2,1) Y(2,2)]);
V(end,1) = var([Y(end,1) Y(end,2) Y(end-1,1) Y(end-1,2)]);
V(1,end) = var([Y(1,end) Y(1,end-1) Y(2,end) Y(2,end-1)]);
V(end,end) = var([Y(end,end) Y(end,end-1) Y(end-1,end) Y(end-1,end-1)]);

%finding the threshold
T = median(median(V));
%polarities matrix
P = zeros(32,32);
for i = 1:32
    for j = 1:32
        if V(i,j) <= T
            P(i,j) = 0;
        else
            P(i,j) = 1;
        end
    end
end

%key1
key1 = zeros(32,32);
for i = 1:32
    key1(i,:) = randperm(32);
end
%permuting the watermark
permW = zeros(32,32);
for i = 1:32 %for each row in the watermark
    for j = 1:32 
        element = key1(i,j);
        permW(i,j) = W(i,element);
    end
end

%key2
key2 = zeros(32,32);
for i = 1:size(P,1)
    for j = 1:size(P,2)
        key2(i,j) = xor(P(i,j),permW(i,j));
    end
end
%step 11
[clusters,centers] = kmeans(True);
%making new block vectors by replacing the blocks with their closest
%centriod
Xp = zeros(256,1024);
for i = 1:20
    indexs = clusters{i};
    for j = 1:length(indexs)
        Xp(:,indexs(j)) = centers(:,i);
    end
end

%making the reconstructed image by reversing the block process
reconstructed_again = uint8(zeros(size(True)));

k = 1;
for i = 1:step:512
    for j = 1:step:512
        block = Xp(:,k);
        block = reshape(block,16,16);
        reconstructed_again(i:i+step-1,j:j+step-1) = block;
        k = k+1;
    end
end

%Re-compute the variance and polarities matrices from this image.

[clusters2,centers2] = kmeans(reconstructed_again);
Y0 = 1:1024;
Y0 = reshape(Y0,32,32)';
Y = zeros(32,32);
for i = 1:20
    values = clusters2{i};
    for j = 1:length(values)
        [x,y] = find(Y0==values(j));
        Y(x,y) = i;
    end
end

%variance matrix
V = zeros(32,32);
for i = 2:31
    for j = 2:31
        %3x3 neighborhood
        V(i,j) = var([Y(i,j) Y(i-1,j-1) Y(i-1,j) Y(i-1,j+1) Y(i,j-1) Y(i,j+1) Y(i+1,j-1) Y(i+1,j) Y(i+1,j+1)]);
    end
end
for j = 2:31
    %top and bottom rows
    V(1,j) = var([Y(1,j-1) Y(1,j) Y(1,j+1) Y(2,j-1) Y(2,j) Y(2,j+1)]);
    V(end,j) = var([Y(end,j-1) Y(end,j) Y(end,j+1) Y(end-1,j-1) Y(end-1,j) Y(end-1,j+1)]);
end
for i = 2:31
    %left and right columns
    V(i,1) = var([Y(i-1,1) Y(i,1) Y(i+1,1) Y(i-1,2) Y(i,2) Y(i+1,2)]);
    V(i,end) = var([Y(i-1,end) Y(i,end) Y(i+1,end) Y(i-1,end-1) Y(i,end-1) Y(i+1,end-1)]);
end
%corners
V(1,1) = var([Y(1,1) Y(1,2) Y(2,1) Y(2,2)]);
V(end,1) = var([Y(end,1) Y(end,2) Y(end-1,1) Y(end-1,2)]);
V(1,end) = var([Y(1,end) Y(1,end-1) Y(2,end) Y(2,end-1)]);
V(end,end) = var([Y(end,end) Y(end,end-1) Y(end-1,end) Y(end-1,end-1)]);

%finding the threshold
T = median(median(V));
%approximate polarities matrix
Papprox = zeros(32,32);
for i = 1:32
    for j = 1:32
        if V(i,j) <= T
            Papprox(i,j) = 0;
        else
            Papprox(i,j) = 1;
        end
    end
end

for i = 1:size(P,1)
    for j = 1:size(P,2)
        permWf(i,j) = xor(key2(i,j),Papprox(i,j));
    end
end

finalW = zeros(32,32);
for i = 1:32 %for each row in the permuted watermark
    for j = 1:32 
        element = key1(i,j);
        finalW(i,element) = permWf(i,j);
    end
end

imshow(uint8(finalW.*255))




function [clusters,centers] = kmeans(img)
kDist = 1;
iter = 0;
X = [];
step = 16;
%splitting into blocks
k = 1;
for i = 1:step:512
    for j = 1:step:512
        block = img(i:i+step-1,j:j+step-1);
        block = reshape(block,1,256);
        X(:,k) = block;
        k = k+1;
    end
end

%initailze 20 random centers
r = randperm(1024);
r = sort(r(1:20));
centers = zeros(256,20);
for i = 1:20
    centers(:,i) = X(:,r(i));
end



while kDist > 1e-6
    
%compute euclidean distance of each block to each center
%each block will have 20 distances
distances = zeros(20,1024);
for i = 1:20 %for each center
    for j = 1:1024 %for each block
        d = sum(((centers(:,i) - X(:,j)).^2).^.5);
        distances(i,j) = d;
    end
end

%Label each block vector with the number of the center it is closest to
blocklabels = zeros(1,1024);
for i = 1:1024
    [M,index] = min(distances(:,i));
    blocklabels(i) = index;
end

%recompute the centers by taking the average of the block vectors assigned to each group.
centersNew = zeros(step*step,20);
clusters = {};
for i = 1:20
    %find which blocks are closest to centers 1 to 20
    indexs = find(blocklabels == i);
    clusters{i} = indexs;
    for j = 1:length(indexs)
    %    add each closest block to the new center
        index = indexs(j);
        centersNew(:,i) = centersNew(:,i) + X(:,index);
    end
   % divide by the amount of closest blocks
    centersNew(:,i) = centersNew(:,i)./length(indexs);
end

%Compute the distance between each of the K new centers and each of the K old centers. 
%This will be used for iteration.
kDistances = zeros(1,20);
for i = 1:20
    %euclidean distance of centers to oldcenters
    d = sum(((centers(:,i) - centersNew(:,i)).^2).^.5);
    kDistances(i) = d;
end
kDist = sum(kDistances);
centers = centersNew;
iter = iter+1;
end 
end

