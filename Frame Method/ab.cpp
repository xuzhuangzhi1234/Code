#include "stdafx.h"  
#include "highgui.h"  
#include "cxcore.h"  
#include "ml.h"  
#include "cv.h"  
#include "mex.h"  
void main()  
{  
    CvCapture* capture;  
    capture=cvCaptureFromFile("a.avi");//获取视频  
    cvNamedWindow("camera",CV_WINDOW_AUTOSIZE);  
    cvNamedWindow("moving area",CV_WINDOW_AUTOSIZE);  
  
      
    IplImage* tempFrame;//用于遍历capture中的帧，通道数为3，需要转化为单通道才可以处理  
    IplImage* currentFrame;//当前帧  
    IplImage* previousFrame;//上一帧  
    /* 
    CvMat结构，本质上和IplImage差不多，但是因为IplImage里的数据只能用uchar的形式存放，当需要这些图像数据看作数据矩阵来运算时，0~255的精度显然满足不了要求； 
然而CvMat里却可以存放任意通道数、任意格式的数据 
    */  
    CvMat* tempFrameMat;  
    CvMat* currentFrameMat; //IplImage要转成CvMat进行处理  
    CvMat* previousFrameMat;  
  
    int frameNum=0;  
    while(tempFrame=cvQueryFrame(capture))  
    {  
        //tempFrame=cvQueryFrame(capture);  
        frameNum++;  
        if(frameNum==1)  
        {  
            //第一帧先初始化各个结构，为它们分配空间  
            previousFrame=cvCreateImage(cvSize(tempFrame->width,tempFrame->height),IPL_DEPTH_8U,1);  
            currentFrame=cvCreateImage(cvSize(tempFrame->width,tempFrame->height),IPL_DEPTH_8U,1);  
            currentFrameMat=cvCreateMat(tempFrame->height, tempFrame->width, CV_32FC1);  
            previousFrameMat=cvCreateMat(tempFrame->height, tempFrame->width, CV_32FC1);  
            tempFrameMat=cvCreateMat(tempFrame->height, tempFrame->width, CV_32FC1);  
            //此时这些IplImage和CvMat都是空的，没有存有数据  
        }  
        if(frameNum>=2)  
        {  
            cvCvtColor(tempFrame, currentFrame, CV_BGR2GRAY);//转化为单通道灰度图，此时currentFrame已经存了tempFrame的内容  
            /* 
            用cvConvert将IplImage转为CvMat，接下来用cvAbsDiff对它们处理 
            经过转换后，currentFrame没有改变，但是tempFrameMat已经存了currentFrame的内容 
            */  
            cvConvert(currentFrame,tempFrameMat);  
            cvConvert(previousFrame,previousFrameMat);  
  
            cvAbsDiff(tempFrameMat,previousFrameMat,currentFrameMat);//做差求绝对值  
            /* 
            在currentFrameMat中找大于20（阈值）的像素点，把currentFrame中对应的点设为255 
            此处阈值可以帮助把车辆的阴影消除掉 
            */  
            cvThreshold(currentFrameMat,currentFrame,20,255.0,CV_THRESH_BINARY);  
            //cvConvert(currentFrameMat,currentFrame); //观察不二值化的情况  
  
            cvDilate(currentFrame,currentFrame);  //膨胀  
            cvErode(currentFrame,currentFrame);   //腐蚀  
            cvFlip(currentFrame, NULL, 0);  //垂直翻转  
            //显示图像  
            cvShowImage("camera",tempFrame);  
            cvShowImage("moving area",currentFrame);  
        }  
        //把当前帧保存作为下一次处理的前一帧  
        cvCvtColor(tempFrame, previousFrame, CV_BGR2GRAY);  
        cvWaitKey(33);  
  
    }//end while  
  
    //释放资源  
    cvReleaseImage(&tempFrame);  
    cvReleaseImage(&previousFrame);  
    cvReleaseImage(&currentFrame);  
      
    cvReleaseCapture(&capture);  
    cvReleaseMat(&previousFrameMat);  
    cvReleaseMat(&currentFrameMat);  
    cvDestroyWindow("camera");  
    cvDestroyWindow("moving area");  
}  