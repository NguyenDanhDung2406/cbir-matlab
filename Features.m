function Features(hObject, eventdata, handles, numOfReturnedImages,metric)
% input:
%   numOfReturnedImages : num of images returned by query
%   queryImageFeatureVector: query image in the form of a feature vector
%   dataset: the whole dataset of images transformed in a matrix of
%   features
% 
% output: 
%   plot: plot images returned by query

guidata(hObject, handles);
siradata = getappdata(0, 'siradata');

if (~isfield(handles, 'imagedataset'))
    errordlg('Vui long chon tap du lieu hoac tao ra chung !');
    return;
else
    dataset = getappdata(siradata,'dataset');
end

if (isappdata(siradata, 'queryimagename'))
    
    queryimagename = str2num(getappdata(siradata,'queryimagename'));
else
    errordlg('Please select image for search!');
    return;
end

if(isappdata(siradata,'feedbackdataset'))
    handles.feedbackdataset = getappdata(siradata,'feedbackdataset');
else
    if(exist('feedbackdatabase','file')==0)
        mkdir 'feedbackdatabase';
        filepath = fileparts('feedbackdatabase/');
    else
        filepath = fileparts('feedbackdatabase/');
    end
    filepath = fullfile(filepath,strcat('feedback_',getappdata(siradata,'imagedatasetname'),'.mat'));
    
    if(exist(filepath,'file') == 0)
        [rows,cols] = size(dataset);
        feedbackdataset = int32.empty(rows,0);
        feedbackdataset(1:rows,1:rows) = 0;
        save(filepath,'feedbackdataset');
        clear('feedbackdataset');
    else
        fprintf('Database Exist...Loading Dataset...\r\n');
    end
    handles.feedbackdataset = load(filepath);
    handles.feedbackdataset = handles.feedbackdataset.feedbackdataset;
    guidata(hObject, handles);
    setappdata(siradata, 'feedbackdataset', handles.feedbackdataset);
    setappdata(siradata, 'feedbackpath', filepath);
end    


queryImageFeatureVector = handles.query_image_feature;
% doc hinh anh truy van trong tap duu lieu
query_image_name = queryImageFeatureVector(:, end);
dataset_image_names = dataset(:, end);
queryImageFeatureVector(:, end) = [];
dataset(:, end) = [];

manhattan = zeros(size(dataset, 1), 1);
progress_bar = waitbar(0,'Loading...','Name','SIRA - Vui long cho giay lat!','CreateCancelBtn','setappdata(gcbf,''cancel_callback'',1)');
setappdata(progress_bar,'cancel_callback',0);
steps = size(dataset, 1);
for k = 1:size(dataset, 1)
    % ralative manhattan distance
    if getappdata(progress_bar,'cancel_callback')
        break;
    end
    waitbar(k/steps,progress_bar,sprintf('Loading...%.2f%%',k/steps*100));
    manhattan(k) = sum( abs(dataset(k, :) - queryImageFeatureVector) ./ ( 1 + dataset(k, :) + queryImageFeatureVector ) );
end
% add anh vao mang manhattan
manhattan = [manhattan dataset_image_names];
%%%%%%%%%
% sap xep khoang cach tang dan
[sortedDist indx] = sortrows(manhattan);
sortedImgs = sortedDist(:, 2);
delete(progress_bar)

% clear axes
arrayfun(@cla, findall(0, 'type', 'axes'));
arrayfun(@cla, findall(0, 'type', 'checkbox'));
str_name = int2str(query_image_name);
query_img = imread( strcat('images\', str_name, '.jpg') );
imshow(query_img, []);
% hien thi anh  returned by query
xaxes=300;
yaxes=500;
cnt=0;
imageitr=1;
for m = 1 : size(sortedImgs)
    img_name = sortedImgs(m);
    img_no = img_name;
    if(~(handles.feedbackdataset(queryimagename,img_no) == -1))
        if imageitr <= numOfReturnedImages
            img_name = int2str(img_name);
            str_name = strcat('images\', img_name, '.jpg');
            returnedImage = imread(str_name);
            ha = axes('Units','Pixels','Position',[xaxes,yaxes,100,100]);
            imshow(returnedImage,[]);
             
            if (handles.feedbackdataset(queryimagename,img_no) == 1)
                checkbox(imageitr) = uicontrol('Style','checkbox',...
                                    'string',img_no,'value',1,'tag',sprintf('checkbox%d',imageitr),...
                                    'Position',[xaxes+85 yaxes+85 20 20]);
            else
                checkbox(imageitr) = uicontrol('Style','checkbox',...
                                    'string',img_no,'tag',sprintf('checkbox%d',imageitr),...
                                    'Position',[xaxes+85 yaxes+85 20 20]);
            end
            xaxes = xaxes+90;
            cnt=cnt+1;
            if mod(cnt,8)== 0
                yaxes=yaxes-110;
                xaxes=300;
            end
            imageitr=imageitr+1;
        else
            break;
        end
    end
end

%%% xu ly tinh do chinh xac
% dan nhan cho anh query
b=[];
c=[];
str_name = int2str(query_image_name);
query_img = imread( strcat('images\', str_name, '.jpg') );
subplot(3, 8, 1);
imshow(query_img, []);
y=str2num(str_name);
if y >=0 && y <=1000
    c=[c;y(:)];
end
img_names = c(:, end);
% dan nhan cho anh query
lbls = zeros(length(c), 1);
for k = 0:length(lbls)-1
    if (query_image_name(k+1) >= 1 && query_image_name(k+1) <= 100)
        lbls(k+1) = 1;
    elseif (query_image_name(k+1) >= 101 && query_image_name(k+1) <= 200)
        lbls(k+1) = 2;
    elseif (query_image_name(k+1) >= 201 && query_image_name(k+1) <= 300)
        lbls(k+1) = 3;
    elseif (query_image_name(k+1) >= 301 && query_image_name(k+1) <= 400)
        lbls(k+1) = 4;
    elseif (query_image_name(k+1) >= 401 && query_image_name(k+1) <= 500)
        lbls(k+1) = 5;
    elseif (query_image_name(k+1) >= 501 && query_image_name(k+1) <= 600)
        lbls(k+1) = 6;
    elseif (query_image_name(k+1) >= 601 && query_image_name(k+1) <= 700)
        lbls(k+1) = 7;
    elseif (query_image_name(k+1) >= 701 && query_image_name(k+1) <= 800)
        lbls(k+1) = 8;
    elseif (query_image_name(k+1) >= 801 && query_image_name(k+1) <= 900)
        lbls(k+1) = 9;
    elseif (query_image_name(k+1) >= 901 && query_image_name(k+1) <= 1000)
        lbls(k+1) = 10;
    end
end
for m = 1:numOfReturnedImages
    img_name = sortedImgs(m);
    img_name = int2str(img_name);
    % dua nhg id anh vao mang
    x=str2num(img_name);
    if x >=0 && x <=1000
        b=[b;x(:)];
    end
end
img_names = b(:, end);
% img_names = int2str(img_name);
% dan nhan cho cac anh tra ve
lbl = zeros(length(b), 1);
for k = 0:length(lbl)-1
    if (img_names(k+1) >= 1 && img_names(k+1) <= 100)
        lbl(k+1) = 1;
    elseif (img_names(k+1) >= 101 && img_names(k+1) <= 200)
        lbl(k+1) = 2;
    elseif (img_names(k+1) >= 201 && img_names(k+1) <= 300)
        lbl(k+1) = 3;
    elseif (img_names(k+1) >= 301 && img_names(k+1) <= 400)
        lbl(k+1) = 4;
    elseif (img_names(k+1) >= 401 && img_names(k+1) <= 500)
        lbl(k+1) = 5;
    elseif (img_names(k+1) >= 501 && img_names(k+1) <= 600)
        lbl(k+1) = 6;
    elseif (img_names(k+1) >= 601 && img_names(k+1) <= 700)
        lbl(k+1) = 7;
    elseif (img_names(k+1) >= 701 && img_names(k+1) <= 800)
        lbl(k+1) = 8;
    elseif (img_names(k+1) >= 801 && img_names(k+1) <= 900)
        lbl(k+1) = 9;
    elseif (img_names(k+1) >= 901 && img_names(k+1) <= 1000)
        lbl(k+1) = 10;
    end
end
%Tinh do chinh xac 
d=0;
% so sanh de lay ra cac anh cung nhan 
for i = 1:length(lbl)
    if lbl(i) == lbls
        d = d + 1;
%         img_name = sortedImgs(i);
%         img_name = int2str(img_name);
%         str_img_name = strcat('images\', img_name, '.jpg');
%         returned_img = imread(str_img_name);
%         subplot(3, 7, d+1);
%         imshow(returned_img, []);
    end
end

z = ( d/handles.no_of_return_images )*100;
z = num2str(z);
set(handles.text6,'String',[z,'%']);
setappdata(siradata,'numOfReturnedImages',numOfReturnedImages);
setappdata(siradata,'sortedImgs',sortedImgs);
setappdata(siradata,'checkbox',checkbox);
% setappdata(siradata,'no_cluster',k);
% arrayfun(@cla, findall(0, 'type', 'chekbox'));
btn = uicontrol('Style','pushbutton','String','Feedback',...
                'Position', [1000 17 100 50],...
                'BackgroundColor',[1.0,0.5,0.0],...
                'ForegroundColor',[1.0,1.0,1.0],...
                'Callback', {@feedback,guidata(hObject)});
guidata(hObject,handles);
end