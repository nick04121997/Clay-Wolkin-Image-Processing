test_img = [1 2 1; 2 3 2; 1 2 1;];
imwrite(test_img,'testing123.png');
imshow('testing123.png');
x = nearest_neighbor(test_img, 0);

