
img=data/rsfmri.nii.gz
out=output/rsfmri
if [[ -s ${out}_avg.nii.gz ]] ; then 
  ThresholdImage 3 ${out}_avg.nii.gz  ${out}_bmask.nii.gz 300 9999 #fortex
  ImageMath 3 ${out}_bmask.nii.gz GetLargestComponent ${out}_bmask.nii.gz #fortex
  ImageMath 4 ${out}compcorr.nii.gz CompCorrAuto ${out}.nii.gz ${out}_bmask.nii.gz 6 #fortex
  sccan --timeseriesimage-to-matrix [ ${out}compcorr_corrected.nii.gz , ${out}_bmask.nii.gz , 0 , 1.0 ] -o ${out}.csv #fortex
  sccan --svd sparse[ ${out}.csv ,  ${out}_bmask.nii.gz , -0.05 ] -n 40 -i 20 --PClusterThresh 50 -o ${out}RSFNodes.nii.gz  #fortex
fi
exit

# R stuff
dd<-read.csv('output/rsfmriMOCOparams.csv')
wh<-c(2:length(dd$MOCOparam0)) ; wh2<-wh-1> 
pdf('../figures/rsfmriplot1.pdf',width=8,height=6); 
plot(discon,ylab="Change in rotation",xlab="Time",cex=2,cex.lab=1.5,cex.axis=1.25,cex.main=2, lwd=2,lty=2,font=1,font.sub=2,font.main=2,font.lab=2,type="l",main="Outlier Rejection") ; 
dev.off()
pdf('../figures/rsfmriplot2.pdf',width=8,height=6); 
plot(dd$MetricPost,ylab="Negative Correlation with Average",xlab="Time",cex=2,cex.lab=1.5,cex.axis=1.25,cex.main=2, lwd=2,lty=2,font=1,font.sub=2,font.main=2,font.lab=2,type="l",main="Outlier Rejection") ; 
dev.off()