//
//  ViewController.m
//  opencvtest1
//
//  Created by Yanliang Gu on 9/6/15.
//  Copyright (c) 2015 Yanliang Gu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize imageView;
@synthesize imageView2;
@synthesize imageView3;
@synthesize peakLabel1;
@synthesize peakLabel2;
@synthesize peakLabel3;
@synthesize callBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    newImage = [UIImage imageNamed:@"barcode-blur.png"];
    //newImage = [UIImage imageNamed:@"barcode_sample_3.png"];
    //imageView.image = newImage;
    
    [self calcPixelHist:newImage];
    //imageView.image =newImage;
    cv::Mat colorMat;
    colorMat = [self cvMatFromUIImage:newImage];
    cv::Mat greyMat;
    cv::cvtColor(colorMat, greyMat, CV_BGR2GRAY);
    
    cv::Mat imgx;
    cv::Sobel(greyMat, imgx, CV_32F, 1, 0);
    imgx = abs(imgx);
    cv::Mat imgy;
    cv::Sobel(greyMat, imgy, CV_32F, 0, 1);
    cv::Mat imgSub;
    cv::subtract(imgx, imgy, imgSub);
    cv::Mat imgScale;
    cv::convertScaleAbs(imgSub, imgScale);
    
    cv::Mat imgBlur;
    cv::Size_<int> ksize;
    ksize.height = 5;
    ksize.width = 5;
    cv::blur(imgScale, imgBlur, ksize);
    
    cv::Mat thresh;
    cv::threshold(imgBlur, thresh, 20, 255, CV_THRESH_BINARY);
    
    ksize.width = 30;
    ksize.height = 7;
    cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, ksize);
    
    cv::Mat closed;
    cv::morphologyEx(thresh, closed, cv::MORPH_CLOSE, kernel);
    cv::erode(closed, closed, kernel);
    cv::dilate(closed, closed, kernel);
    
    std::vector<std::vector<cv::Point> > contours;
    cv::findContours(closed, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    cv::Rect rect = cv::boundingRect(contours[0]);
    cv::Point pt1;
    pt1.x = rect.x;
    pt1.y = rect.y;
    cv::Point pt2;
    pt2.x = rect.x+rect.width;
    pt2.y = rect.y+rect.height;
    
//    int element_size = 10;
//    cv::Mat ker = cv::getStructuringElement( cv::MORPH_ELLIPSE,cv::Size( 2*element_size + 1, 2*element_size+1 ),cv::Point( element_size, element_size ));
    
//            for(int i=0;i<thresh.rows;i++){
//                for (int j=0; j<thresh.cols; j++) {
//                    char intensity = thresh.at<char>(i, j);
//                    NSLog(@"%d",(int)intensity);
//                }
//            }
    
//        for(int i=0;i<greyMat.rows;i++){
//            for (int j=0; j<greyMat.cols; j++) {
//                cv::Vec4b intensity = greyMat.at<cv::Vec4b>(i, j);
//                NSLog(@"%f",(float)intensity.val[3]);
//            }
//        }
//    cv::Mat gaussianMat;
//    cv::Size_<int> ksize;
//    ksize.height = 1;
//    ksize.width = 1;
//    cv::GaussianBlur(greyMat, gaussianMat, ksize, 0.01);
//    cv::Mat gradX;
//    cv::Mat gradY;
//    cv::Sobel(greyMat, gradX, CV_32F, 1, 0);
//    cv::Sobel(greyMat, gradY, CV_32F, 0, 1);
//    cv::Mat gradient;
//    
//    cv::subtract(gradX, gradY, gradient);
//    cv::Mat gradientAbs;
//    cv::convertScaleAbs(gradient, gradientAbs);
//    
//    cv::Size_<int> ksize;
//    ksize.height = 9;
//    ksize.width = 9;
//    cv::Mat blurArr;
//    cv::blur(gradientAbs, blurArr, ksize);
//    //imageView2.image =[self UIImageFromCVMat:blurArr];
//    cv::Mat blurArrp;
////            for(int i=0;i<blurArr.rows;i++){
////                for (int j=0; j<blurArr.cols; j++) {
////                    cv::Vec4b intensity = blurArr.at<cv::Vec4b>(i, j);
////                    NSLog(@"%f",(float)intensity.val[3]);
////                }
////            }
//    cv::threshold(blurArr, blurArrp, 10, 255, cv::THRESH_BINARY);
//    
//    cv::Mat kernel;
//    ksize.width = 21;
//    ksize.height = 7;
//    kernel = cv::getStructuringElement(cv::MORPH_RECT, ksize);
//    
//    cv::Mat closed;
//    cv::morphologyEx(blurArrp, closed, cv::MORPH_CLOSE, kernel);
//    
//    cv::erode(closed, closed, 2);
//    cv::dilate(closed, closed, 5);
//    
//    //std::vector<std::vector<cv::Point> > cnts;
////    cv::Seq<int> cnts;
////    cv::MemStorage sto;
//    std::vector<std::vector<cv::Point> > contours;
//    cv::findContours(closed, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
//
//    double area = 0;
//    double max_area = 0;
//    for(int i=0;i<contours.size();i++){
//        
//        area = fabs(contourArea(contours[i]));
//        if (area>max_area)
//        {
//            max_area=area;
//            
//        }
//    }
//    
//    //double max_area = cv::contourArea(contours[0]);
//    //NSLog(@"%f",max_area);
//    //int area = 0;
//    //cv::minAreaRect(contours[0]);
////    cv::RotatedRect rect = cv::minAreaRect(contours[0]);
////    std::vector<cv::Point> box;
////    cv::boxPoints(rect, box);

    greyMat.mul(thresh);
    //NSLog(@"%d",thresh.type());
    cv::Mat mask = cv::Mat::zeros(greyMat.rows, greyMat.cols, CV_8UC1);
    //cv::drawContours(mask, contours, -1, cv::Scalar(100,100,0),CV_FILLED);
    //cv::rectangle(greyMat, pt1, pt2, CV_RGB(0, 0, 0));
    int histSize = 256;
    float range[] = { 0, 256 } ; //the upper boundary is exclusive
    const float* histRange = { range };
    bool uniform = true; bool accumulate = false;
    cv::Mat b_hist, g_hist, r_hist;
    
    cv::calcHist(&closed, 1, 0, cv::Mat(), b_hist, 1, &histSize, &histRange);
//            for(int i=0;i<b_hist.rows;i++){
//                for (int j=0; j<b_hist.cols; j++) {
//                    float intensity = b_hist.at<float>(i, j);
//                    NSLog(@"%f",intensity);
//                }
//            }
    //imageView2.image =[self UIImageFromCVMat:greyMat.mul(closed)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (cv::Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                    cols,                       // Width of bitmap
                                                    rows,                       // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat
{
    NSLog(@"%d",cvMat.cols);
    NSLog(@"%d",cvMat.rows);
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

- (void)calcHist:(UIImage *)srcImg{
    cv::Mat src;
    src = [self cvMatFromUIImage:srcImg];
    std::vector<cv::Mat> rbg_planes;
    cv::split(src, rbg_planes);
    /// Establish the number of bins
    int histSize = 256;
    
    /// Set the ranges ( for B,G,R) )
    float range[] = { 0, 256 } ;
    const float* histRange = { range };
    
    bool uniform = true; bool accumulate = false;
    
    cv::Mat b_hist, g_hist, r_hist;

    cv::calcHist( &rbg_planes[0], 1, 0, cv::Mat(), b_hist, 1, &histSize, &histRange, uniform, accumulate );
    cv::calcHist( &rbg_planes[1], 1, 0, cv::Mat(), g_hist, 1, &histSize, &histRange, uniform, accumulate );
    cv::calcHist( &rbg_planes[2], 1, 0, cv::Mat(), r_hist, 1, &histSize, &histRange, uniform, accumulate );
    
    int hist_w = 512; int hist_h = 400;
    int bin_w = cvRound( (double) hist_w/histSize );
    
    cv::Mat histImage( hist_h, hist_w, CV_8UC3, cv::Scalar( 0,0,0) );
    
    normalize(b_hist, b_hist, 0, histImage.rows, cv::NORM_MINMAX, -1, cv::Mat() );
    normalize(g_hist, g_hist, 0, histImage.rows, cv::NORM_MINMAX, -1, cv::Mat() );
    normalize(r_hist, r_hist, 0, histImage.rows, cv::NORM_MINMAX, -1, cv::Mat() );
    
    for( int i = 1; i < histSize; i++ )
    {
        cv::line( histImage, cv::Point( bin_w*(i-1), hist_h - cvRound(b_hist.at<float>(i-1)) ) ,
             cv::Point( bin_w*(i), hist_h - cvRound(b_hist.at<float>(i)) ),
             cv::Scalar( 255, 0, 0), 2, 8, 0  );
        cv::line( histImage, cv::Point( bin_w*(i-1), hist_h - cvRound(g_hist.at<float>(i-1)) ) ,
                 cv::Point( bin_w*(i), hist_h - cvRound(g_hist.at<float>(i)) ),
                 cv::Scalar( 0, 255, 0), 2, 8, 0  );
        cv::line( histImage, cv::Point( bin_w*(i-1), hist_h - cvRound(r_hist.at<float>(i-1)) ) ,
                 cv::Point( bin_w*(i), hist_h - cvRound(r_hist.at<float>(i)) ),
                 cv::Scalar( 0, 0, 255), 2, 8, 0  );
    }
    
    imageView2.image =[self UIImageFromCVMat:histImage];
}

- (void)calcPixelHist:(UIImage *)srcImg{
    cv::Mat src1 = [self cvMatFromUIImage:srcImg];
    cv::Mat src2 = src1.clone();
    cv::Mat src3 = src1.clone();
    
    cv::Mat greySrc;
    cv::cvtColor(src1, greySrc, CV_BGR2GRAY);
    
    cv::Mat greyRow1 = greySrc.row(20);
    cv::Mat greyRow2 = greySrc.row(50);
    cv::Mat greyRow3 = greySrc.row(80);
    
    int peakCount = 0;
    BOOL peakFlag = false;
    for(int i=1; i<greyRow1.cols-1; i++){
        uchar intensity1 = greyRow1.at<uchar>(0, i-1);
        uchar intensity2 = greyRow1.at<uchar>(0, i);
        uchar intensity3 = greyRow1.at<uchar>(0,i+1);
        if ((float)intensity2>(float)intensity1 && (float)intensity2>(float)intensity3) {
            peakFlag = false;
            peakCount++;
        }
        else if((float)intensity2>(float)intensity1 && (float)intensity2<=(float)intensity3){
            peakFlag = true;
        }
        else if((float)intensity2<=(float)intensity1 && (float)intensity2>(float)intensity3 && peakFlag){
            peakFlag = false;
            peakCount++;
        }
        cv::line( src1, cv::Point((i-1),cvRound((float)intensity1)-50) ,
                 cv::Point( i,cvRound((float)intensity2)-50),
                 cv::Scalar( 255, 0, 0), 2, 8, 0  );
    }
    cv::line(src1, cv::Point(0,20), cv::Point(greyRow1.cols,20), cv::Scalar( 255, 255, 0), 1, 8, 0);
    NSLog(@"peak:%d",peakCount);
    peakLabel1.text = [NSString stringWithFormat:@"Peak: %d",peakCount];
    imageView.image =[self UIImageFromCVMat:src1];
    
    peakCount = 0;
    peakFlag = false;
    for(int i=1; i<greyRow2.cols-1; i++){
        uchar intensity1 = greyRow2.at<uchar>(0, i-1);
        uchar intensity2 = greyRow2.at<uchar>(0, i);
        uchar intensity3 = greyRow2.at<uchar>(0,i+1);
        if ((float)intensity2>(float)intensity1 && (float)intensity2>(float)intensity3) {
            peakFlag = false;
            peakCount++;
        }
        else if((float)intensity2>(float)intensity1 && (float)intensity2<=(float)intensity3){
            peakFlag = true;
        }
        else if((float)intensity2<=(float)intensity1 && (float)intensity2>(float)intensity3 && peakFlag){
            peakFlag = false;
            peakCount++;
        }
        cv::line( src2, cv::Point((i-1),cvRound((float)intensity1)-50 ) ,
                 cv::Point( i,cvRound((float)intensity2)-50),
                 cv::Scalar( 255, 0, 0), 2, 8, 0  );
    }
    cv::line(src2, cv::Point(0,50), cv::Point(greyRow1.cols,50), cv::Scalar( 255, 255, 0), 1, 8, 0);
    peakLabel2.text = [NSString stringWithFormat:@"Peak: %d",peakCount];
    imageView2.image =[self UIImageFromCVMat:src2];

    peakCount = 0;
    peakFlag = false;
    for(int i=1; i<greyRow3.cols-1; i++){
        uchar intensity1 = greyRow3.at<uchar>(0, i-1);
        uchar intensity2 = greyRow3.at<uchar>(0, i);
        uchar intensity3 = greyRow3.at<uchar>(0,i+1);
        if ((float)intensity2>(float)intensity1 && (float)intensity2>(float)intensity3) {
            peakFlag = false;
            peakCount++;
        }
        else if((float)intensity2>(float)intensity1 && (float)intensity2<=(float)intensity3){
            peakFlag = true;
        }
        else if((float)intensity2<=(float)intensity1 && (float)intensity2>(float)intensity3 && peakFlag){
            peakFlag = false;
            peakCount++;
        }
        cv::line( src3, cv::Point((i-1),cvRound((float)intensity1)-50 ) ,
                 cv::Point( i,cvRound((float)intensity2)-50),
                 cv::Scalar( 255, 0, 0), 2, 8, 0  );
    }
    cv::line(src3, cv::Point(0,80), cv::Point(greyRow1.cols,80), cv::Scalar( 255, 255, 0), 1, 8, 0);
    peakLabel3.text = [NSString stringWithFormat:@"Peak: %d",peakCount];
    imageView3.image =[self UIImageFromCVMat:src3];
    //cv::Range rowRange(100,101);
    //NSLog(@"rows:%d, cols:%d",greySrc.rows,greySrc.cols);
    //NSLog(@"rows:%d, cols:%d",greyRow.rows,greyRow.cols);
//    for (int i = 0;i<greySrc.cols ; i++) {
//        uchar intensity = greyRow.at<uchar>(0, i);
//        NSLog(@"%d:%f",i,(float)intensity);
//    }
}

- (IBAction)callFacetime:(id)sender {
    NSURL *facetimeUrl = [[NSURL alloc]initWithString:@"facetime://9063700842"];
    UIApplication *application = [UIApplication sharedApplication];
    if ([application canOpenURL:facetimeUrl]) {
        [application openURL:facetimeUrl];
    }
}
@end
