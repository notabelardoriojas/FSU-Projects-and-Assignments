%Uncomment based on what image you're using.

%a = imread ( 'red.png');
%a = imread ( 'gradient16.png');
a = imread ( 'choiceC.png');
[ m, n ] = size ( a );


%CURVE PLOT
 order = log2(m);
 dim = 2^order;
[x,y] = hilbert(order);
 x = x + .5;
 y = y + .5;
line(x,y);
xlim([0 1])
ylim([0 1])
xticks(0:1/dim:1)
yticks(0:1/dim:1)
grid on
xy = 2^(order+1)*[x' y'];
xy = (xy+1)/2;


[r, g, b] = hilbertRead(a);
%squishing the color values between 0 and 1
max = 255;
min = 0;
r = 2*(r(1,:) - min)./(max-min);
g = 2*(g(1,:) - min)./(max-min);
b = 2*(b(1,:) - min)./(max-min);
%creating a sawtooth wave
T = (dim*dim)*(1/50);
fs = 1000;
t = 0:1/fs:T-1/fs;

saw = sawtooth(2*pi*50*t);
%using the red color values as scalars for each sawtoon wave
%each period is sampled 20 times.
for i = 1:dim^2
    saw(1,1+(20*(i-1)):20*i)=saw(1,1+(20*(i-1)):20*i)*r(1,i);
end

%same as sawtooth, but with green color values.
T = (dim*dim)*(1/50);
fs = 1000;
t = 0:1/fs:T-1/fs;
tri = sawtooth(2*pi*50*t,1/2);
for i = 1:dim^2
    tri(1,1+(20*(i-1)):20*i)=tri(1,1+(20*(i-1)):20*i)*g(1,i);
end

%generating square waves and using blue values as scalars.
t = 0:1/1e3:size(saw,2)/1000;
square = square(2*pi*30*t,50);
for i = 1:dim^2
    square(1,1+(20*(i-1)):20*i)=square(1,1+(20*(i-1)):20*i)*b(1,i);
end
%random clipping at the end to make everything even
square(end) = [];
t(end)=[];

%the big wave is the average of all 3 waves.
bigwave = tri+square+saw/3;
%writes audio to the file
audiowrite('sample.wav', bigwave,fs);

%sound(bigwave,fs); %uncomment to hear sound


% %visual aid%
% str = 'frame';
% frames = size(r,2);
% points = [];
% for i = 1:frames
%     points = [points;xy(i,1) xy(i,2)];
%     
%     num = string(sprintf( '%03d', i ));
%     filename = strcat(str,num);
%     filename = strcat(filename,'.png');
%     set(gca,'xticklabel',{[]});
%     set(gca,'yticklabel',{[]});
%     set(gca,'visible','on');
%     set(0,'DefaultFigureVisible','off')
%     fh = figure('Menu','none','ToolBar','none'); 
%     ah = axes('Units','Normalize','Position',[0 0 1 1]);
%     fig = gcf;
%     fig.PaperUnits = 'inches';
%     fig.PaperPosition = [0 0 10 10];
%     line(points(:,1),points(:,2));
%     xlim([0 1])
%     ylim([0 1])
%     xticks(0:1/dim:1)
%     yticks(0:1/dim:1)
%     grid on;
%     saveas(gcf,filename);
%     
% end


function [red, green, blue] = hilbertRead(image)
%this function reads the image's pixels in the order of the hilbert curve
[ m, ~ ] = size ( image );
image = flipud(image); %gotta flip it upsidedown to read it correctly. 1,1 is at the top left corner
order = log2(m);
dim = 2^order;
[x,y] = hilbert(order);
x = x + .5;
y = y + .5;
xy = 2^(order+1)*[x' y']; %scale it so 1,1 is the first pixel
xy = (xy+1)/2;
red = zeros(1,dim*dim);
green = zeros(1,dim*dim);
blue = zeros(1,dim*dim);
for i = 1:dim*dim %generates red green and blue arrays to transform into audio
    col = xy(i,1);
    row = xy(i,2);
    red(1,i) = image(row,col,1);
    green(1,i) = image(row,col,2);
    blue(1,i) = image(row,col,3);
end
end
function [x,y] = hilbert(n)
    %uses a recursive funciton to plot the hilbert curve
    if n<=0
      x=0;
      y=0;
    else
      [xo,yo]=hilbert(n-1);
      %all points are scaled and then shifted to make the curve
      x=.5*[-.5+yo -.5+xo .5+xo  .5-yo];
      y=.5*[-.5+xo  .5+yo .5+yo -.5-xo];
    end
end