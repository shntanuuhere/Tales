#import "ImageGallerySaverPlugin.h"
#import <Photos/Photos.h>

@implementation ImageGallerySaverPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"image_gallery_saver"
            binaryMessenger:[registrar messenger]];
  ImageGallerySaverPlugin* instance = [[ImageGallerySaverPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"saveImageToGallery" isEqualToString:call.method]) {
    NSData *imageData = [(FlutterStandardTypedData*)call.arguments[@"imageBytes"] data];
    NSInteger quality = [call.arguments[@"quality"] integerValue];
    NSString *name = call.arguments[@"name"];
    
    [self saveImageWithData:imageData quality:quality name:name result:result];
  } else if ([@"saveFileToGallery" isEqualToString:call.method]) {
    NSString *path = call.arguments[@"filePath"];
    NSString *name = call.arguments[@"name"];
    
    [self saveFileWithPath:path name:name result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)saveImageWithData:(NSData *)imageData quality:(NSInteger)quality name:(NSString *)name result:(FlutterResult)result {
  UIImage *image = [UIImage imageWithData:imageData];
  if (quality < 100) {
    imageData = UIImageJPEGRepresentation(image, quality / 100.0);
  }
  
  __block PHObjectPlaceholder *placeholder;
  
  [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
    [request addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
    if (name) {
      request.creationDate = [NSDate date];
      request.location = [[CLLocation alloc] initWithLatitude:0 longitude:0];
    }
    placeholder = request.placeholderForCreatedAsset;
  } completionHandler:^(BOOL success, NSError *error) {
    if (success) {
      NSString *assetId = placeholder.localIdentifier;
      result(@{@"isSuccess": @(YES), @"filePath": assetId});
    } else {
      result(@{@"isSuccess": @(NO), @"errorMessage": error.description});
    }
  }];
}

- (void)saveFileWithPath:(NSString *)path name:(NSString *)name result:(FlutterResult)result {
  NSData *data = [NSData dataWithContentsOfFile:path];
  if (!data) {
    result(@{@"isSuccess": @(NO), @"errorMessage": @"File does not exist"});
    return;
  }
  
  NSString *fileExtension = [path pathExtension];
  BOOL isVideo = [@[@"mp4", @"mov", @"avi"] containsObject:[fileExtension lowercaseString]];
  
  __block PHObjectPlaceholder *placeholder;
  
  [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    if (isVideo) {
      PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
      [request addResourceWithType:PHAssetResourceTypeVideo fileURL:[NSURL fileURLWithPath:path] options:nil];
      if (name) {
        request.creationDate = [NSDate date];
        request.location = [[CLLocation alloc] initWithLatitude:0 longitude:0];
      }
      placeholder = request.placeholderForCreatedAsset;
    } else {
      PHAssetCreationRequest *request = [PHAssetCreationRequest creationRequestForAsset];
      [request addResourceWithType:PHAssetResourceTypePhoto data:data options:nil];
      if (name) {
        request.creationDate = [NSDate date];
        request.location = [[CLLocation alloc] initWithLatitude:0 longitude:0];
      }
      placeholder = request.placeholderForCreatedAsset;
    }
  } completionHandler:^(BOOL success, NSError *error) {
    if (success) {
      NSString *assetId = placeholder.localIdentifier;
      result(@{@"isSuccess": @(YES), @"filePath": assetId});
    } else {
      result(@{@"isSuccess": @(NO), @"errorMessage": error.description});
    }
  }];
}

@end
