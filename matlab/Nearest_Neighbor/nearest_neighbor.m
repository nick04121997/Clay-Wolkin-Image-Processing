function [ img_cat ] = nearest_neighbor( input_img, bayer_filter )
%     image = imfinfo(input_img);    
%     width = image.Width;
%     height = image.Height;

    [height, width] = size(input_img);
    
    red = zeros(height, width);
    blue = zeros(height, width);
    green = zeros(height, width);
    
    switch bayer_filter
    case 0 %'rggb'
        for col = 1:width
            for row = 1:height
                if(mod(row,2)==1 && mod(col, 2)==1)
                    red(row, col) = input_img(row, col);
                elseif(mod(row,2)==0 && mod(col, 2)==0)
                    blue(row, col) = input_img(row, col);
                elseif((mod(row,2)== 1 && mod(col,2) == 0) ...
                        || (mod(row,2)==0 && mod(col,2) ==1))
                    green(row, col) = input_img(row, col);  
                end 
            end
        end
 
        
    case 1 %'bggr'
        for col = 1:width
            for row = 1:height
                if(mod(row,2)==1 && mod(col, 2)==1)
                    blue(row, col) = input_img(row, col);
                elseif(mod(row,2)==0 && mod(col, 2)==0)
                    red(row, col) = input_img(row, col);
                elseif((mod(row,2)== 1 && mod(col,2) == 0) ...
                        || (mod(row,2)==0 && mod(col,2) ==1))
                    green(row, col) = input_img(row, col);
                end 
            end
        end
                    
    case 2 %'grbg'
        for col = 1:width
            for row = 1:height
                if(mod(row,2)==0 && mod(col,2)==1)
                    blue(row, col) = input_img(row, col);
                elseif(mod(row,2)==1 && mod(col, 2)==0)
                    red(row, col) = input_img(row, col);
                elseif((mod(row,2)== 0 && mod(col,2) == 0) ...
                        || (mod(row,2)==1 && mod(col,2)==1))
                    green(row, col) = input_img(row, col); 
                end
            end
        end
      case 3 %'gbrg'
        for col = 1:width
            for row = 1:height
                if(mod(row,2)==1 && mod(col, 2)==0)
                    blue(row, col) = input_img(row, col);
                elseif(mod(row,2)==0 && mod(col, 2)==1)
                    red(row, col) = input_img(row, col);
                elseif((mod(row,2)== 0 && mod(col,2) == 0) ...
                        || (mod(row,2)==1 && mod(col,2)==1))
                    green(row, col) = input_img(row, col);           
                end
            end
        end
    end         
    
    for col = 1:width
        for row = 1:height
            if(mod(row, 2)==1 && mod(col,2)==0)
                red(row,col) = red(row,col-1);
            elseif(mod(row, 2)==0)
                red(row, col) = red(row-1, col);
            end
            
            if(mod(row,2)==0 && mod(col,2)==1)
                if(col == width)
                    blue(row,col) = blue(row,col-1);
                else
                    blue(row,col) = blue(row, col+1);
                end
            elseif(mod(row,2)==1 && mod(col,2)==1)
                if(col == width && row == height)
                    blue(row, col) = blue(row-1,col-1);
                elseif(col == width)
                    blue(row,col) = blue(row+1, col-1);
                elseif(row == height)
                    blue(row, col) = blue(row-1, col+1);
                else
                    blue(row,col) = blue(row+1, col+1);
                end
            elseif(mod(row,2)==1 && mod(col,2)==0)
                if(row == height)
                    blue(row, col) = blue(row-1, col);
                else
                    blue(row, col) = blue(row+1, col);
                end
            end 
            
            if(mod(row,2)==1 && mod(col,2)==1)
                if(row == width)
                    green(row,col) = green(row-1,col);
                else
                    green(row,col) = green(row+1,col);
                end
            elseif(mod(row,2)==0 && mod(col,2)==0)
                green(row,col) = green(row, col-1);
            end
            
        end
    end
    
     

disp(red);
disp(green);
disp(blue);
end
% 
