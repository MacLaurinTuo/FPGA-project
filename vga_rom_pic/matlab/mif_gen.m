clear %清理命令行窗口
clc %清理工作区
% 使用 imread 函数读取图片,并转化为三维矩阵
image_array = imread('image.bmp');

% 使用 size 函数计算图片矩阵三个维度的大小
% 第一维为图片的高度，第二维为图片的宽度，第三维为图片维度
[height,width,z]=size(image_array); % 100*100*3
red = image_array(:,:,1); % 提取红色分量，数据类型为 uint8
green = image_array(:,:,2); % 提取绿色分量，数据类型为 uint8
blue = image_array(:,:,3); % 提取蓝色分量，数据类型为 uint8

% 使用 reshape 函数将各个分量重组成一个一维矩阵
%为了避免溢出,将 uint8 类型的数据扩大为 uint32 类型
r = uint32(reshape(red' , 1 ,height*width));
g = uint32(reshape(green' , 1 ,height*width));
b = uint32(reshape(blue' , 1 ,height*width));

% 初始化要写入.mif 文件中的 RGB 颜色矩阵
rgb=zeros(1,height*width);

% 导入的图片为 24bit 真彩色图片,每个像素占用 24bit,RGB888
% 将 RGB888 转换为 RGB565
% 红色分量右移 3 位取出高 5 位,左移 11 位作为 ROM 中 RGB 数据的第 15bit 到第 11bit
% 绿色分量右移 2 位取出高 6 位,左移 5 位作为 ROM 中 RGB 数据的第 10bit 到第 5bit
% 蓝色分量右移 3 位取出高 5 位,左移 0 位作为 ROM 中 RGB 数据的第 4bit 到第 0bit
for i = 1:height*width
    rgb(i) = bitshift(bitshift(r(i),-3),11) + bitshift(bitshift(g(i),-2),5) + bitshift(bitshift(b(i),-3),0);
end

fid = fopen( 'image.mif', 'w+' );

% .mif 文件字符串打印
fprintf( fid, 'WIDTH=16;\n');
fprintf( fid, 'DEPTH=%d;\n\n',height*width);

fprintf( fid, 'ADDRESS_RADIX=UNS;\n');
fprintf( fid, 'DATA_RADIX=HEX;\n\n');

fprintf(fid,'%s\n\t','CONTENT');
fprintf(fid,'%s\n','BEGIN');

% 写入图片数据
for i = 1:height*width
    fprintf(fid,'\t\t%d\t:%x\t;\n',i-1,rgb(i));
end
% 打印结束字符串
fprintf(fid,'\tEND;');
fclose( fid ); % 关闭文件指针
