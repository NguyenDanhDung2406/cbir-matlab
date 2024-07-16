function feedback(hObject,eventdata,handles,text6)
%UNTITLED Summary of this function goes here,
%   Detailed explanation goes here
% % check for image query
% hObject
% guidata(hObject,handles);
siradata=getappdata(0,'siradata');
dataset = getappdata(siradata,'dataset');
guidata(hObject, handles);
if (isappdata(siradata, 'feedbackdataset'))
    handles.feedbackdataset=getappdata(siradata,'feedbackdataset');
else
    errordlg('FEEDBACK: VUI LONG TAI feedbackdataset !');
    return;
end
if (isappdata(siradata, 'numOfReturnedImages'))
    handles.no_of_return_images=getappdata(siradata,'numOfReturnedImages');
else
    errordlg('FEEDBACK: VUI LONG TAI numOfReturnedImages !');
    return;
end


if (isappdata(siradata, 'sortedImgs'))
    handles.sortedImgs=getappdata(siradata,'sortedImgs');
else
    errordlg('FEEDBACK: VUI LONG TAI sortedImgs!');
    return;
end

if (isappdata(siradata, 'checkbox'))
    handles.checkbox=getappdata(siradata,'checkbox');
else
    errordlg('FEEDBACK: VUI LONG CHON checkbox !');
    return;
end

if (isappdata(siradata, 'feedbackpath'))
    handles.feedbackpath=getappdata(siradata,'feedbackpath');
else
    errordlg('FEEDBACK: VUI LÒNG TẢI feedbackpath !');
    return;
end

if (isappdata(siradata, 'dataset'))
    handles.dataset=getappdata(siradata,'dataset');
    %     handles.dataset=datasethandler.dataset;
else
    errordlg('FEEDBACK: FEEDBACK: VUI LÒNG CẬP NHẬT TẬP DỮ LIỆU !');
    return;
end
if (isappdata(siradata, 'queryimagename') || isappdata(siradata, 'queryimagepath') || isappdata(siradata, 'queryimageext'))
    queryimagename=str2num(getappdata(siradata, 'queryimagename'));
    queryImagepath=getappdata(siradata, 'queryimagepath');
    queryImageext=getappdata(siradata,'queryimageext');
else
    errordlg('FEEDBACK: VUI LÒNG CẬP NHẬT TẬP DỮ LIỆU !');
    return;
end
% fullfile( queryImagepath, strcat(queryimagename, queryImageext) )
% queryImage = imread( fullfile( queryImagepath, strcat(queryimagename, queryImageext) ) );
%Anh phan hoi gan val==1
for m=1:handles.no_of_return_images
    val=get(handles.checkbox(m),'Value');
    image_no=str2num(get(handles.checkbox(m),'string'));
    if (handles.feedbackdataset(queryimagename,image_no) == 0) && (val == 0)
        handles.feedbackdataset(queryimagename,image_no)= -1;
    elseif (handles.feedbackdataset(queryimagename,image_no) == 1) && (val == 1)
        handles.feedbackdataset(queryimagename,image_no)= val;
    elseif (handles.feedbackdataset(queryimagename,image_no) == 0) && (val == 1)
        handles.feedbackdataset(queryimagename,image_no)= val;
    elseif (handles.feedbackdataset(queryimagename,image_no) == -1) && (val == 1)
        handles.feedbackdataset(queryimagename,image_no)= val;
    end
end

% location=handles.feedbackpath;
% feedbackdataset=handles.feedbackdataset;
% save(location,'feedbackdataset');
% clear('handles.feedbackdataset','feedbackdataset');
% handles.feedbackdataset=load(handles.feedbackpath);
% handles.feedbackdataset=handles.feedbackdataset.feedbackdataset;
% setappdata(siradata, 'feedbackdataset',handles.feedbackdataset);

tic
% %truyen data feedback
handles.imagedataset.dataset
a = handles.imagedataset.dataset
% handles.no_cluster
b=[];
% logreg = []; 
% ytrain = zeros(handles.no_of_return_images,1);
% Lay anh tich chon dua vao mang
for m = 1:handles.no_of_return_images
    val = get(handles.checkbox(m),'Value');
    image_no = str2num(get(handles.checkbox(m),'string'));
    x = str2num(get(handles.checkbox(m),'string'));
%     logreg = [logreg;image_no(:)];
    if val == 1
        b = [b;x(:)];
%         ytrain(m,1) = 1;
    end
end
%phan lop
c=[];
name = a(:,end)
c = ismember(name, b)

indexes = find(c)
% indexes1 = find(logreg)

feedback = a(indexes,:)
% feedback1 = a(indexes1,:)%truyen feature vao cho feedback

% xtrain = feedback1(:,1:2048) %gan cac feature cho train


%%%%%%%%%%%%%%%%%%%%%
% link = @(mu) log(mu ./ (1-mu));
% derlink = @(mu) 1 ./ (mu .* (1-mu));
% invlink = @(resp) 1 ./ (1 + exp(-resp));
% F = {link, derlink, invlink};
% dungnd = glmfit(xtrain,ytrain,'binomial','link',F)
% xtest = a(:,1:2048)
% logistic function
% xtrain=zscore(xtrain(:,1:end));% Normaliz   ed Predictors
% p=length(a);
% xtrain =[ones(length(xtrain),1) xtrain];
% compute cost and gradient
% iter=1000; % No. of iterations for weight updation
% theta = zeros(size(xtrain,2),1); % Initial weights
% alpha = 0.1 % Learning parameter
% [J grad h th]=cost(theta,xtrain,ytrain,alpha,iter) % Cost funtion
% ypred=xtest*th; %target prediction
% [hp]=sigmoid(ypred); % Hypothesis Function

%%%%%
k = 5;
[idx,C,sumd,D] = kmeans(feedback(:,1:2048),k);
% query_image_feature = rows(C)
[height, width] = size(C) % lay do dai cua hang va cot trong C

% query theo tung tam cum
d = 0;
% query cum
dataset_image_names = dataset(:, end);
dataset(:, end) = [];
queryImageFeatureVector = get(handles.checkbox(m),'Value');
queryImageFeatureVector(:, end) = [];
manhattan = zeros(size(dataset, 1), 1);
progress_bar = waitbar(0,'Loading...','Name','SIRA-Vui long cho trong giay lat ! ','CreateCancelBtn','setappdata(gcbf,''cancel_callback'',1)');
setappdata(progress_bar,'cancel_callback',0);
steps = size(dataset, 1);
% dua cum vao truy van
for j = 1:size(dataset, 1)
    if getappdata(progress_bar,'cancel_callback')
        break;
    end
    waitbar(j/steps,progress_bar,sprintf('Loading...%.2f%%',j/steps*100));
    for h = 1:size(C, 1)
        Centroid = feedback(h,1:2048);
        queryImageFeatureVector = Centroid;
        manhattan(j) = sum( abs(dataset(j, :) - queryImageFeatureVector) ./ ( 1 + dataset(j, :) + queryImageFeatureVector ) );
        d = d + manhattan(j);
    end
    manhattan(j) = d;
    d = 0;
end

manhattan = [manhattan dataset_image_names];
delete(progress_bar)
% Ranking tập ảnh sử dụng độ đo manhattan
sortDist = sortrows(manhattan,1);
sortedImgs = sortDist(:, 2);% Lấy id ảnh tương ứng
% set(handles.text6,'String',[z,'%']);
% clear axes
arrayfun(@cla, findall(0, 'type', 'axes'));
arrayfun(@cla, findall(0, 'type', 'checkbox'));
xaxes=300;
yaxes=500;
cnt=0;
imageitr=1;

for m = 1 : size(sortedImgs)% show result of kmeans
    img_name = sortedImgs(m);
    img_no = img_name;
        if imageitr <= handles.no_of_return_images
            img_name = int2str(img_name); %Doc ten anh
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
            xaxes = xaxes+110;
            cnt=cnt+1;
            if mod(cnt,8)==0
                yaxes=yaxes-110;
                xaxes=300;
            end
            imageitr=imageitr+1;
        else
            break;
        end
end
toc
arrayfun(@cla, findall(0, 'type', 'text'));
b=[];
c=[];
queryImageFeatureVector = handles.query_image_feature;
% Dua anh truy van vao dataset so sanh
query_image_name = queryImageFeatureVector(:, end);
dataset_image_names = dataset(:, end);
queryImageFeatureVector(:, end) = [];
handles.query_image_feature
str_name = int2str(query_image_name);
query_img = imread( strcat('images\', str_name, '.jpg') );
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
for m = 1:handles.no_of_return_images
    img_name = sortedImgs(m);
    img_name = int2str(img_name);
    % dua nhg id anh vao mang
    x = str2num(img_name);
    if x >=0 && x <=1000
        b = [b;x(:)];
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
    end
end

z = ( d / handles.no_of_return_images ) * 100;
z = num2str(z);
set(handles.text6,'String',[z,'%']);


setappdata(siradata,'no_of_return_images',handles.no_of_return_images);
setappdata(siradata,'sortedImgs',sortedImgs);
setappdata(siradata,'checkbox',checkbox);


% clear('handles.feedbackdataset','feedbackdataset');
% handles.feedbackdataset=handles.sortedImgs;
% % handles.feedbackdataset=handles.feedbackdataset.feedbackdataset;
% setappdata(siradata, 'feedbackdataset',handles.feedbackdataset);
helpdlg('Phan hoi lien quan thanh cong !');


% end