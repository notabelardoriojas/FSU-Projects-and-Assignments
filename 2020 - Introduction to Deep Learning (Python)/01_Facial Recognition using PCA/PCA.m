close all
[n,m] = size(imread('archive/s1/1.pgm'));
subjects = 40;
subjectPhotos = 10;
%PREALLOCATING ARRAYS AND READING IN IMAGES
data = zeros(n*m,subjects*subjectPhotos);
count = 1;
for i = 1:subjects
    for j = 1:subjectPhotos
        directory = sprintf('archive/s%d/%d.pgm',i,j);
        a = imread(directory);
        [n,m] = size(a);
        a = reshape(a,m*n,1);
        data(:,count) = a;
        count = count+1;
    end
end

%CASTING FROM UINT8 TO DOUBLE AND PREALLOCATING ARRAYS
data = double(data);
training = zeros(n*m,1);
gallery = zeros(n*m,1);
testing = zeros(n*m,1);

%SEPARATING DATASETS FIRST DATA SET
for i = 0:subjects-1
    testing(:,end+1) = data(:,i*10+1);
    testing(:,end+1) = data(:,i*10+2);
    training(:,end+1) = data(:,i*10+3);
    training(:,end+1) = data(:,i*10+4);
    training(:,end+1) = data(:,i*10+5);
    training(:,end+1) = data(:,i*10+6);
    gallery(:,end+1) = data(:,i*10+7);
    gallery(:,end+1) = data(:,i*10+8);
    gallery(:,end+1) = data(:,i*10+9);
    gallery(:,end+1) = data(:,i*10+10);
end
%SECOND DATASET
% for i = 0:subjects-1
%     testing(:,end+1) = data(:,i*10+9);
%     testing(:,end+1) = data(:,i*10+10);
%     training(:,end+1) = data(:,i*10+1);
%     training(:,end+1) = data(:,i*10+2);
%     training(:,end+1) = data(:,i*10+3);
%     training(:,end+1) = data(:,i*10+4);
%     gallery(:,end+1) = data(:,i*10+5);
%     gallery(:,end+1) = data(:,i*10+6);
%     gallery(:,end+1) = data(:,i*10+7);
%     gallery(:,end+1) = data(:,i*10+8);
% end


%OOPS
testing(:,1) = [];
training(:,1) = [];
gallery(:,1) = [];

%MEAN CENTERING DATA
meanTest = zeros(n*m,1);
meanTrain = zeros(n*m,1);
meanGallery = zeros(n*m,1);
for i = 1:n*m
    meanTest(i) = mean(testing(i,:));
    meanTrain(i) = mean(training(i,:));
    meanGallery(i) = mean(gallery(i,:));
end

for i = 1:160
    training(:,i) = training(:,i) - meanTrain;
    gallery(:,i) = gallery(:,i) - meanGallery;
end

for i = 1:80
    testing(:,i) = testing(:,i) - meanTest;
end

meanface = zeros(n*m,1);
%AVERAGEFACE
for i = 1:n*m
    meanface(i) = mean(data(i,:));
end

meanface = uint8(reshape(meanface,n,m));
imwrite(meanface,'meanface.png')

%training set covariance matrix

quasiCov = training' * training;

%getting eigenvalues and vectors
[V,D] = eig(quasiCov);
%turning eigvalues into list
for i = 1:160
    eigval(i,1) = D(i,i);
end
%putting indicies on the side
eigval(:,2) = 1:160;
%sorting by first row
eigval = flipud(sortrows(eigval,1));
[j,k] = size(V);

%sorting eigvectors for PCs
PCs = zeros(j,k);
for i = 1:160
    PCs(:,i) = V(:,eigval(i,2));
end

%making the E matrix
E = training * PCs;
%first 5 PCs
for i = 1:10
e1 = uint8(reshape(E(:,i),n,m));
imwrite(e1,sprintf('eigenface%d.png',i));
end
%last 5 PCs
for i = 0:9
e2 = uint8(reshape(E(:,end-i),n,m));
imwrite(e2,sprintf('eigenface%d.png',160-i));
end

PCnumber = 50;
%making the basis matrix
basis = E(:,1:PCnumber);
%projecting into PCA Space
projGallery = zeros(n*m,80);
projTesting = zeros(n*m,160);
for j = 1:160
    projection = zeros(n*m,1);
    for i = 1:PCnumber
    b1 = basis(:,i);
    projection = projection + (b1' * gallery(:,j) * b1);
    end
    projGallery(:,j) = projection;
end

for j = 1:80
    projection = zeros(n*m,1);
    for i = 1:PCnumber
    b1 = basis(:,i);
    projection = projection + (b1' * testing(:,j) * b1);
    end
    projTesting(:,j) = projection;
end

%getting weights for comparison


weightsGallery = zeros(160,PCnumber);
weightsTesting = zeros(160,PCnumber);

for i = 1:160
    for j = 1:PCnumber
    weightsGallery(i,j) = basis(:,j)' * gallery(:,i);
    end
end

for i = 1:80
    for j = 1:PCnumber
    weightsTesting(i,j) = basis(:,j)' * testing(:,i);
    end
end

%Comparing the Images in the Gallery and Testing Datasets
d = zeros(80,160);
for i = 1:80
    for j = 1:160
        for k = 1:PCnumber
        Eval = eigval(k,1);
        d(i,j)= d(i,j) + (1/Eval) * (weightsTesting(i,k) - weightsGallery(j,k)).^2;
        end
     end % Note: ?(K) is the Eigenvalue of the Kth Basis Set vector!
end

matchcount = 0;

for i = 1:2:80
    rows = d(i:i+1,:);
    minimum = min(min(rows));
    [x,y] = find(rows==minimum);
    individual = ceil(i/2);
    small = ceil(y/4);
    figure
    if small == individual
        matchcount = matchcount + 1;
        sgtitle('Correctly made match');
    else
        fprintf('PCA misclassified subject %d as subject %d\n',individual, small);
        sgtitle('Incorrectly made match');
    end
    subplot(1,2,1);
    dirtest = sprintf('archive/s%d/%d.pgm',individual,x);
%     dirtest = sprintf('archive/s%d/%d.pgm',individual,x+8); %second dataset uses different logic
    testimg = imshow(imread(dirtest));
    title(['Test image: ' dirtest]);
    subplot(1,2,2);
    dirgallery = sprintf('archive/s%d/%d.pgm',small,(y/4 - floor(y/4))*4+7);
%     dirgallery = sprintf('archive/s%d/%d.pgm',small,(y/4 - floor(y/4))*4+5); %second dataset uses different logic
    galleryimg = imshow(imread(dirgallery));
    title(['Gallery image: ' dirgallery]);
    
end

%random rows
[z,~] = size(d);
nums = randi([1 z], 2, 1);
row1 = d(nums(1),:);
row2 = d(nums(2),:);
mini1 = min(min(row1));
mini2 = min(min(row2));
[x1,y1] = find(row1==mini1);
[x2,y2] = find(row2==mini2);
dirtest1 = sprintf('archive/s%d/%d.pgm',ceil(nums(1)/2),x1);
% dirtest1 = sprintf('archive/s%d/%d.pgm',ceil(nums(1)/2),x1); %second data set
dirtest2 = sprintf('archive/s%d/%d.pgm',ceil(nums(2)/2),x2);
% dirtest2 = sprintf('archive/s%d/%d.pgm',ceil(nums(2)/2),x2+8);
dirgallery1 = sprintf('archive/s%d/%d.pgm',ceil(y1/4),((y1/4 - floor(y1/4))*4+7));
% dirgallery1 = sprintf('archive/s%d/%d.pgm',ceil(y1/4),((y1/4 - floor(y1/4))*4+5)); %second data set
dirgallery2 = sprintf('archive/s%d/%d.pgm',ceil(y2/4),((y2/4 - floor(y2/4))*4+7));
% dirgallery2 = sprintf('archive/s%d/%d.pgm',ceil(y2/4),((y2/4 - floor(y2/4))*4+5));
figure
subplot(1,2,1);
testimg1 = imshow(imread(dirtest1));
title(['Test image: ' dirtest1]);
subplot(1,2,2);
galleryimg1 = imshow(imread(dirgallery1));
title(['Gallery image: ' dirgallery1]);
sgtitle('Randomly chosen rows')

figure
subplot(1,2,1);
testimg2 = imshow(imread(dirtest2));
title(['Test image: ' dirtest2]);
subplot(1,2,2);
galleryimg2 = imshow(imread(dirgallery2));
title(['Gallery image: ' dirgallery2]);
sgtitle('Randomly chosen rows')



matchPct = matchcount/subjects
figure
x = [5 10 20 30 40 50];
y = [.8 .925 .975 .975 .975 .975];
plot(x,y);
xlabel('Number of eigenfaces')
ylabel('Percentage accuracy')




