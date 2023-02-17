
clc
clear all
close all

video = VideoReader('cc.mp4'); % video upload step. video path

% Separating foreground from background using Gaussian blending models (moving object detection)
ObjectDetector = vision.ForegroundDetector('NumGaussians', 3, 'NumTrainingFrames', 300, 'MinimumBackgroundRatio', 0.3 );

for i = 1:100
frame = readFrame(video);
Object = step(ObjectDetector, frame);
end

% Noise removal step
NoiseRemoval = strel('square', 2); % Adjusted to clear values less than 2 px

% The step of boxing the object, determining the center of gravity of the box
% we used the "BlobAnalysis" properties to query the area of the box by opening it and defining it in separate variables
Bounding_Box = vision.BlobAnalysis('BoundingBoxOutputPort', true, 'AreaOutputPort', false, 'CentroidOutputPort', false, 'MinimumBlobArea', 1900);
Bounding_Centre_Point = vision.BlobAnalysis('BoundingBoxOutputPort', false, 'AreaOutputPort', false, 'CentroidOutputPort', true, 'MinimumBlobArea', 1900);
Bounding_Area = vision.BlobAnalysis('BoundingBoxOutputPort', false, 'AreaOutputPort', true, 'CentroidOutputPort', false, 'MinimumBlobArea', 1900);

% Step of opening a video window, naming it and determining its size
videoPlayer = vision.VideoPlayer('Name', 'Vehicle Tracking and Counting');
videoPlayer.Position(3:4) = [1000,610];


first_lane_counter=0; secont_lane_counter=0; third_lane_counter=0; % first_lane_counter,secont_lane_counter,third_lane_counter variables names of lanes
First_Lane_Switch=1; Secont_Lane_Switch=1; Third_Lane_Switch=1; % The variables First_Lane_Switch,Secont_Lane_Switch,Third_Lane_Switch are related to turning strip counting on and off
Large_Vehicles_Counter=0; Small_Vehicles_Counter=0; % Variable of Large_Vehicles_Counter and Small_Vehicles_Counter vehicle count
Total_Number_of_Vehicles=0; % Total number of vehicles variable
Large_Car_Box_Space=25000; % Large_Car_Box_Space variable is the box space value we set for large vehicles

% We scanned the video frame by frame with the while loop
while hasFrame(video)
frame = readFrame(video); 
Object = step(ObjectDetector, frame); % we applied the object detector to all frames
Noise_Removed_Image = imopen(Object, NoiseRemoval); % we cleaned the noise frame by frame
Box_Frame_Determination = step(Bounding_Box, Noise_Removed_Image); % we set it around the tools and assign it to the variable
Coordinate_of_Center_Point = step(Bounding_Centre_Point, Noise_Removed_Image); % we set the center of the tools and assign it to the variable
Box_Area_Determination = step(Bounding_Area, Noise_Removed_Image); % we assigned the area of the box determined around the vehicles to the variable
Red_Line = insertShape(frame, 'Line',[110 260 415 260],'LineWidth',5, 'Color', 'red'); % we drew a red line in the left lane
Green_Line = insertShape(Red_Line, 'Line',[415 260 630 260],'LineWidth',5, 'Color', 'green'); % we drew a green line in the middle lane
Yellow_Line = insertShape(Green_Line, 'Line',[630 260 870 260],'LineWidth',5, 'Color', 'yellow'); % we drew a yellow line in the right lane

Box_Drawing = insertShape(Yellow_Line, 'Rectangle', Box_Frame_Determination, 'Color', 'blue', 'LineWidth',2); % We had a blue colored box with a thickness of 2 pixels drawn around the vehicles.

Drawing_the_Center_Point = insertMarker(Box_Drawing, Coordinate_of_Center_Point, '+','color', 'blue', 'size',4  ); % we added a blue "+" icon to the center coordinate of the vehicles
Coordinate_of_Center_Point = size(Coordinate_of_Center_Point, 1); % We set it to 1 pixel so that the resolution of the center coordinate point is higher

Total_Number_of_Vehicles_Text = ['Toplam Araç Sayısı:' ]; Number_of_Small_Vehicles_Text = ['Küçük Araç Sayısı:' ]; Number_of_Large_Vehicles_Text = ['Büyük Araç Sayısı:' ]; % variables of the texts written to the screen
Number_of_Active_Vehicles = insertText(Drawing_the_Center_Point, [10 10], Coordinate_of_Center_Point, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','w'); % Number of vehicles instantly recognized on the screen
Small_Number_of_Vehicles = insertText(Number_of_Active_Vehicles, [775 10], Small_Vehicles_Counter, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','w'); % printing the number of small vehicles to the screen
Large_Number_of_Vehicles = insertText(Small_Number_of_Vehicles, [475 10], Large_Vehicles_Counter, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','w'); % printing large number of vehicles to the screen
Total_Number_of_Vehicles_Text = insertText(Large_Number_of_Vehicles, [60 10], Total_Number_of_Vehicles, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','w'); % Printing "Total Number of Vehicles" on the screen
Total_Number_of_Vehicles = insertText(Total_Number_of_Vehicles_Text, [200 10], Total_Number_of_Vehicles, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','w'); % print the total number of vehicles to the screen
first_lane_counter = insertText(Total_Number_of_Vehicles, [250 260], first_lane_counter, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','red'); % print the number of vehicles passing through the first lane
secont_lane_counter = insertText(first_lane_counter, [515 260], secont_lane_counter, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','green'); % print the number of vehicles passing through the second lane
third_lane_counter = insertText(secont_lane_counter, [745 260], third_lane_counter, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','yellow'); % printing the number of vehicles passing through the third lane
Number_of_Small_Vehicles_Text = insertText(third_lane_counter, [645 10], Number_of_Small_Vehicles_Text, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','w'); % Printing "Small Vehicles" on the screen
Number_of_Large_Vehicles_Text = insertText(Number_of_Small_Vehicles_Text, [345 10], Number_of_Large_Vehicles_Text, 'BoxOpacity', 1, 'FontSize', 14,'BoxColor','w'); Printing "Large Vehicle Number" on the screen

Coordinate_of_Center_Point = round(Coordinate_of_Center_Point); % rounding the value of the center coordinate after the comma


first_lane_first_coordinate_count=[110 235]; first_lane_second_coordinate_count=[415 265]; % first line of each lane (vehicle counting line)
second_lane_first_coordinate_count=[415 235]; second_lane_second_coordinate_count=[630 265]; 
third_lane_first_coordinate_count=[630 235]; third_lane_second_coordinate_count=[870 265]; 

first_lane_first_coordinate_count_open=[110 266]; first_lane_second_coordinate_count_open=[415 296]; % second line of each lane (turns on vehicle counting)
second_lane_first_coordinate_count_open=[415 266]; second_lane_second_coordinate_count_open=[630 296]; 
third_lane_first_coordinate_count_open=[630 266]; third_lane_second_coordinate_count_open=[870 296]; 

Total_Number_of_Vehicles=first_lane_counter+secont_lane_counter+third_lane_counter; % total number of vehicles variable

if(isnan(Coordinate_of_Center_Point)==0) % loops that query and count up to 5 boxes on the first line of each strip and turn off the counting
    if(Coordinate_of_Center_Point(1,:)>=first_lane_first_coordinate_count_open & Coordinate_of_Center_Point(1,:)<=first_lane_second_coordinate_count_open & First_Lane_Switch==1) first_lane_counter=first_lane_counter+1; First_Lane_Switch=0;
        if(Alan(1,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
        else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
        end
    end
    if(Coordinate_of_Center_Point(1,:)>=second_lane_first_coordinate_count_open & Coordinate_of_Center_Point(1,:)<=second_lane_second_coordinate_count_open & Secont_Lane_Switch==1) secont_lane_counter=secont_lane_counter+1; Secont_Lane_Switch=0;
        if(Alan(1,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1; 
        else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
        end
    end
    if(Coordinate_of_Center_Point(1,:)>=third_lane_first_coordinate_count_open & Coordinate_of_Center_Point(1,:)<=third_lane_second_coordinate_count_open & Third_Lane_Switch==1) third_lane_counter=third_lane_counter+1; Third_Lane_Switch=0;
        if(Alan(1,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
        else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
        end
    end 

           if(Coordinate_of_Center_Point==2 & isnan(Coordinate_of_Center_Point(2,:))==0)
              if(Coordinate_of_Center_Point(2,:)>=first_lane_first_coordinate_count_open & Coordinate_of_Center_Point(2,:)<=first_lane_second_coordinate_count_open & First_Lane_Switch==1) first_lane_counter=first_lane_counter+1; First_Lane_Switch=0;
                  if(Alan(2,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                  else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                  end
              end
              if(Coordinate_of_Center_Point(2,:)>=second_lane_first_coordinate_count_open & Coordinate_of_Center_Point(2,:)<=second_lane_second_coordinate_count_open & Secont_Lane_Switch==1) secont_lane_counter=secont_lane_counter+1; Secont_Lane_Switch=0;
                  if(Alan(2,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                  else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                  end
              end
              if(Coordinate_of_Center_Point(2,:)>=third_lane_first_coordinate_count_open & Coordinate_of_Center_Point(2,:)<=third_lane_second_coordinate_count_open & Third_Lane_Switch==1) third_lane_counter=third_lane_counter+1; Third_Lane_Switch=0;
                  if(Alan(2,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                  else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                  end
              end
           end

                if(Coordinate_of_Center_Point==3 & isnan(Coordinate_of_Center_Point(3,:))==0)
                   if(Coordinate_of_Center_Point(3,:)>=first_lane_first_coordinate_count_open & Coordinate_of_Center_Point(3,:)<=first_lane_second_coordinate_count_open & First_Lane_Switch==1) first_lane_counter=first_lane_counter+1; First_Lane_Switch=0;
                       if(Alan(3,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                       else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                       end
                   end
                   if(Coordinate_of_Center_Point(3,:)>=second_lane_first_coordinate_count_open & Coordinate_of_Center_Point(3,:)<=second_lane_second_coordinate_count_open & Secont_Lane_Switch==1) secont_lane_counter=secont_lane_counter+1; Secont_Lane_Switch=0;
                       if(Alan(3,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                       else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                       end
                   end
                   if(Coordinate_of_Center_Point(3,:)>=third_lane_first_coordinate_count_open & Coordinate_of_Center_Point(3,:)<=third_lane_second_coordinate_count_open & Third_Lane_Switch==1) third_lane_counter=third_lane_counter+1; Third_Lane_Switch=0;
                       if(Alan(3,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                       else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                       end
                   end
                end

                    if(Coordinate_of_Center_Point==4 & isnan(Coordinate_of_Center_Point(4,:))==0)
                       if(Coordinate_of_Center_Point(4,:)>=first_lane_first_coordinate_count_open & Coordinate_of_Center_Point(4,:)<=first_lane_second_coordinate_count_open & First_Lane_Switch==1) first_lane_counter=first_lane_counter+1; First_Lane_Switch=0;
                           if(Alan(4,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                           else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                           end
                       end
                       if(Coordinate_of_Center_Point(4,:)>=second_lane_first_coordinate_count_open & Coordinate_of_Center_Point(4,:)<=second_lane_second_coordinate_count_open & Secont_Lane_Switch==1) secont_lane_counter=secont_lane_counter+1; Secont_Lane_Switch=0;
                           if(Alan(4,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                           else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                           end
                       end
                       if(Coordinate_of_Center_Point(4,:)>=third_lane_first_coordinate_count_open & Coordinate_of_Center_Point(4,:)<=third_lane_second_coordinate_count_open & Third_Lane_Switch==1) third_lane_counter=third_lane_counter+1; Third_Lane_Switch=0;
                           if(Alan(4,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                           else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                           end
                       end 
                    end

                    if(Coordinate_of_Center_Point==5 & isnan(Coordinate_of_Center_Point(5,:))==0 & First_Lane_Switch)
                             if(Coordinate_of_Center_Point(5,:)>=first_lane_first_coordinate_count_open & Coordinate_of_Center_Point(5,:)<=first_lane_second_coordinate_count_open & First_Lane_Switch==1) first_lane_counter=first_lane_counter+1; First_Lane_Switch=0;
                                 if(Alan(5,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                                 else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                                 end
                             end
                             if(Coordinate_of_Center_Point(5,:)>=second_lane_first_coordinate_count_open & Coordinate_of_Center_Point(5,:)<=second_lane_second_coordinate_count_open & Secont_Lane_Switch==1) secont_lane_counter=secont_lane_counter+1; Secont_Lane_Switch=0;
                                  if(Alan(5,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                                  else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                                 end
                             end
                             if(Coordinate_of_Center_Point(5,:)>=third_lane_first_coordinate_count_open & Coordinate_of_Center_Point(5,:)<=third_lane_second_coordinate_count_open & Third_Lane_Switch==1) third_lane_counter=third_lane_counter+1; Third_Lane_Switch=0;
                                  if(Alan(5,:)>=Large_Car_Box_Space) Large_Vehicles_Counter=Large_Vehicles_Counter+1;
                                  else Small_Vehicles_Counter=Small_Vehicles_Counter+1;
                                 end
                             end
                          end


    if(Coordinate_of_Center_Point(1,:)>=first_lane_first_coordinate_count & Coordinate_of_Center_Point(1,:)<=first_lane_second_coordinate_count & First_Lane_Switch==0) First_Lane_Switch=1; % the second line of each strip loops querying up to 5 boxes and reopening the counting
    elseif(Coordinate_of_Center_Point(1,:)>=second_lane_first_coordinate_count & Coordinate_of_Center_Point(1,:)<=second_lane_second_coordinate_count & Secont_Lane_Switch==0) Secont_Lane_Switch=1;
    elseif(Coordinate_of_Center_Point(1,:)>=third_lane_first_coordinate_count & Coordinate_of_Center_Point(1,:)<=third_lane_second_coordinate_count & Third_Lane_Switch==0) Third_Lane_Switch=1;
    end

           if(Coordinate_of_Center_Point==2 & isnan(Coordinate_of_Center_Point(2,:))==0)
                if(Coordinate_of_Center_Point(2,:)>=first_lane_first_coordinate_count & Coordinate_of_Center_Point(2,:)<=first_lane_second_coordinate_count & First_Lane_Switch==0) First_Lane_Switch=1;
                elseif(Coordinate_of_Center_Point(2,:)>=second_lane_first_coordinate_count & Coordinate_of_Center_Point(2,:)<=second_lane_second_coordinate_count & Secont_Lane_Switch==0) Secont_Lane_Switch=1;
                elseif(Coordinate_of_Center_Point(2,:)>=third_lane_first_coordinate_count & Coordinate_of_Center_Point(2,:)<=third_lane_second_coordinate_count & Third_Lane_Switch==0) Third_Lane_Switch=1;
                end 
           end

                if(Coordinate_of_Center_Point==3 & isnan(Coordinate_of_Center_Point(3,:))==0)
                    if(Coordinate_of_Center_Point(3,:)>=first_lane_first_coordinate_count & Coordinate_of_Center_Point(3,:)<=first_lane_second_coordinate_count & First_Lane_Switch==0) First_Lane_Switch=1;
                    elseif(Coordinate_of_Center_Point(3,:)>=second_lane_first_coordinate_count & Coordinate_of_Center_Point(3,:)<=second_lane_second_coordinate_count & Secont_Lane_Switch==0) Secont_Lane_Switch=1;
                    elseif(Coordinate_of_Center_Point(3,:)>=third_lane_first_coordinate_count & Coordinate_of_Center_Point(3,:)<=third_lane_second_coordinate_count & Third_Lane_Switch==0) Third_Lane_Switch=1;
                   end
                end

                    if(Coordinate_of_Center_Point==4 & isnan(Coordinate_of_Center_Point(4,:))==0)
                        if(Coordinate_of_Center_Point(4,:)>=first_lane_first_coordinate_count & Coordinate_of_Center_Point(4,:)<=first_lane_second_coordinate_count & First_Lane_Switch==0) First_Lane_Switch=1;
                        elseif(Coordinate_of_Center_Point(4,:)>=second_lane_first_coordinate_count & Coordinate_of_Center_Point(4,:)<=second_lane_second_coordinate_count & Secont_Lane_Switch==0) Secont_Lane_Switch=1;
                        elseif(Coordinate_of_Center_Point(4,:)>=third_lane_first_coordinate_count & Coordinate_of_Center_Point(4,:)<=third_lane_second_coordinate_count & Third_Lane_Switch==0) Third_Lane_Switch=1;
                        end
                    end

                          if(Coordinate_of_Center_Point==5 & isnan(Coordinate_of_Center_Point(5,:))==0)
                             if(Coordinate_of_Center_Point(5,:)>=first_lane_first_coordinate_count & Coordinate_of_Center_Point(5,:)<=first_lane_second_coordinate_count & First_Lane_Switch==0) First_Lane_Switch=1;
                             elseif(Coordinate_of_Center_Point(5,:)>=second_lane_first_coordinate_count & Coordinate_of_Center_Point(5,:)<=second_lane_second_coordinate_count & Secont_Lane_Switch==0) Secont_Lane_Switch=1;
                             elseif(Coordinate_of_Center_Point(5,:)>=third_lane_first_coordinate_count & Coordinate_of_Center_Point(5,:)<=third_lane_second_coordinate_count & Third_Lane_Switch==0) Third_Lane_Switch=1;
                             end
                          end
end

step(videoPlayer,Number_of_Large_Vehicles_Text); % video start step
end