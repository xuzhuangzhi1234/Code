#include "stdafx.h"  
#include "highgui.h"  
#include "cxcore.h"  
#include "ml.h"  
#include "cv.h"  
#include "mex.h"  
void main()  
{  
    CvCapture* capture;  
    capture=cvCaptureFromFile("a.avi");//��ȡ��Ƶ  
    cvNamedWindow("camera",CV_WINDOW_AUTOSIZE);  
    cvNamedWindow("moving area",CV_WINDOW_AUTOSIZE);  
  
      
    IplImage* tempFrame;//���ڱ���capture�е�֡��ͨ����Ϊ3����Ҫת��Ϊ��ͨ���ſ��Դ���  
    IplImage* currentFrame;//��ǰ֡  
    IplImage* previousFrame;//��һ֡  
    /* 
    CvMat�ṹ�������Ϻ�IplImage��࣬������ΪIplImage�������ֻ����uchar����ʽ��ţ�����Ҫ��Щͼ�����ݿ������ݾ���������ʱ��0~255�ľ�����Ȼ���㲻��Ҫ�� 
Ȼ��CvMat��ȴ���Դ������ͨ�����������ʽ������ 
    */  
    CvMat* tempFrameMat;  
    CvMat* currentFrameMat; //IplImageҪת��CvMat���д���  
    CvMat* previousFrameMat;  
  
    int frameNum=0;  
    while(tempFrame=cvQueryFrame(capture))  
    {  
        //tempFrame=cvQueryFrame(capture);  
        frameNum++;  
        if(frameNum==1)  
        {  
            //��һ֡�ȳ�ʼ�������ṹ��Ϊ���Ƿ���ռ�  
            previousFrame=cvCreateImage(cvSize(tempFrame->width,tempFrame->height),IPL_DEPTH_8U,1);  
            currentFrame=cvCreateImage(cvSize(tempFrame->width,tempFrame->height),IPL_DEPTH_8U,1);  
            currentFrameMat=cvCreateMat(tempFrame->height, tempFrame->width, CV_32FC1);  
            previousFrameMat=cvCreateMat(tempFrame->height, tempFrame->width, CV_32FC1);  
            tempFrameMat=cvCreateMat(tempFrame->height, tempFrame->width, CV_32FC1);  
            //��ʱ��ЩIplImage��CvMat���ǿյģ�û�д�������  
        }  
        if(frameNum>=2)  
        {  
            cvCvtColor(tempFrame, currentFrame, CV_BGR2GRAY);//ת��Ϊ��ͨ���Ҷ�ͼ����ʱcurrentFrame�Ѿ�����tempFrame������  
            /* 
            ��cvConvert��IplImageתΪCvMat����������cvAbsDiff�����Ǵ��� 
            ����ת����currentFrameû�иı䣬����tempFrameMat�Ѿ�����currentFrame������ 
            */  
            cvConvert(currentFrame,tempFrameMat);  
            cvConvert(previousFrame,previousFrameMat);  
  
            cvAbsDiff(tempFrameMat,previousFrameMat,currentFrameMat);//���������ֵ  
            /* 
            ��currentFrameMat���Ҵ���20����ֵ�������ص㣬��currentFrame�ж�Ӧ�ĵ���Ϊ255 
            �˴���ֵ���԰����ѳ�������Ӱ������ 
            */  
            cvThreshold(currentFrameMat,currentFrame,20,255.0,CV_THRESH_BINARY);  
            //cvConvert(currentFrameMat,currentFrame); //�۲첻��ֵ�������  
  
            cvDilate(currentFrame,currentFrame);  //����  
            cvErode(currentFrame,currentFrame);   //��ʴ  
            cvFlip(currentFrame, NULL, 0);  //��ֱ��ת  
            //��ʾͼ��  
            cvShowImage("camera",tempFrame);  
            cvShowImage("moving area",currentFrame);  
        }  
        //�ѵ�ǰ֡������Ϊ��һ�δ����ǰһ֡  
        cvCvtColor(tempFrame, previousFrame, CV_BGR2GRAY);  
        cvWaitKey(33);  
  
    }//end while  
  
    //�ͷ���Դ  
    cvReleaseImage(&tempFrame);  
    cvReleaseImage(&previousFrame);  
    cvReleaseImage(&currentFrame);  
      
    cvReleaseCapture(&capture);  
    cvReleaseMat(&previousFrameMat);  
    cvReleaseMat(&currentFrameMat);  
    cvDestroyWindow("camera");  
    cvDestroyWindow("moving area");  
}  