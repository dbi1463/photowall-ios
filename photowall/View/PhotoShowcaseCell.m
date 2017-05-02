//
//  PhotoShowcaseCell.m
//  photowall
//
//  Created by Spirit on 4/30/17.
//  Copyright © 2017 Picowork. All rights reserved.
//

#import "PhotoShowcaseCell.h"

#import <SDWebImage/UIImageView+WebCache.h>

#import "Photo.h"
#import "RestClient.h"

#import "UIView+Utils.h"
#import "UIImageView+WebImage.h"

NSString* const PhotoShowcaseCellIdentifier = @"PhotoShowcaseCell";

@implementation PhotoShowcaseCell {
	CGFloat _minScale;
	CGFloat _lastZoomScale;
	UIImageView* _fullSizeImageView;
	UITapGestureRecognizer* _tapGesture;
}

- (void)setPhoto:(Photo*)photo {
	if (_tapGesture == nil) {
		_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapToResize:)];
		_tapGesture.numberOfTapsRequired = 2;
		[self addGestureRecognizer:_tapGesture];
	}
	if (_fullSizeImageView != nil) {
		[_fullSizeImageView removeFromSuperview];
	}
	[self.loadingIndicator setHidden:NO];
	[self.loadingIndicator startAnimating];
	[self.preivew setHidden:NO];
	[self.preivew setImageWithPath:photo.thumbnailPath andPlaceholder:nil];
	NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [RestClient defaultEndPoint], photo.fullSizeImagePath]];

	_fullSizeImageView = [UIImageView new];
	_fullSizeImageView.tag = [url.absoluteString hash];
	self.scrollView.delegate = self;
	[_fullSizeImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRefreshCached completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		if ([imageURL.absoluteString hash] != _fullSizeImageView.tag) {
			// The UIImageView has been assigned another URL
			return;
		}

		_fullSizeImageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
		_fullSizeImageView.image = image;

		[self.preivew setHidden:YES];
		[self.loadingIndicator setHidden:YES];
		[self.loadingIndicator stopAnimating];
		[self.scrollView setContentSize:image.size];
		[self.scrollView addSubview:_fullSizeImageView];
		
		[self updateZoom];
		[self updateConstraintsWithScale:self.scrollView.zoomScale];
	}];
}

#pragma mark - UIScrollViewDelegate
- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView {
	return _fullSizeImageView;
}

- (void)scrollViewDidZoom:(UIScrollView*)scrollView {
	[self updateConstraintsWithScale:scrollView.zoomScale];
}

- (void)scrollViewDidEndZooming:(UIScrollView*)scrollView withView:(UIView*)view atScale:(CGFloat)scale {
	[self updateConstraintsWithScale:scale];
}

#pragma mark - IBActions
- (IBAction)doubleTapToResize:(id)sender {
	if (self.scrollView.zoomScale < 1.0) {
		[self.scrollView setZoomScale:1.0];
	}
	else {
		[self.scrollView setZoomScale:_minScale];
	}
}

#pragma mark - Private Methods
- (void)updateConstraintsWithScale:(CGFloat)scale {
	CGFloat imageWidth = _fullSizeImageView.image.size.width;
	CGFloat imageHeight = _fullSizeImageView.image.size.height;
	
	CGFloat viewWidth = self.scrollView.bounds.size.width;
	CGFloat viewHeight = self.scrollView.bounds.size.height;
	
	// center image if it is smaller than screen
	CGFloat scaledImageWidth = scale * imageWidth;
	CGFloat scaledImageHeight = scale * imageHeight;
	CGFloat hPadding = (viewWidth - scaledImageWidth) / 2;
	if (hPadding < 0) {
		hPadding = 0;
	}

	float vPadding = (viewHeight - scaledImageHeight) / 2;
	if (vPadding < 0) {
		vPadding = 0;
	}

	self.scrollView.contentSize = CGSizeMake(scaledImageWidth, scaledImageHeight);
	_fullSizeImageView.frame = CGRectMake(hPadding, vPadding, scaledImageWidth, scaledImageHeight);
}

// Zoom to show as much image as possible unless image is smaller than screen
- (void)updateZoom {
	_minScale = MIN(self.scrollView.bounds.size.width / _fullSizeImageView.image.size.width,
					self.scrollView.bounds.size.height / _fullSizeImageView.image.size.height);

	if (_minScale > 1) {
		_minScale = 1;
	}

	self.scrollView.minimumZoomScale = _minScale;
	
	// Force scrollViewDidZoom fire if zoom did not change
	if (_minScale == _lastZoomScale) {
		_minScale += 0.000001;
	}
	
	_lastZoomScale = self.scrollView.zoomScale = _minScale;
}

@end
