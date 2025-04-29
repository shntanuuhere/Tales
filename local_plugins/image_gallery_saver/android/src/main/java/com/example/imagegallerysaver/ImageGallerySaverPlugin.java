package com.example.imagegallerysaver;

import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** ImageGallerySaverPlugin */
public class ImageGallerySaverPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "image_gallery_saver");
    context = flutterPluginBinding.getApplicationContext();
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("saveImageToGallery")) {
      byte[] image = call.argument("imageBytes");
      String quality = call.argument("quality");
      String name = call.argument("name");

      result.success(saveImageToGallery(BitmapFactory.decodeByteArray(image, 0, image.length),
              quality != null ? Integer.parseInt(quality) : 80, name));
    } else if (call.method.equals("saveFileToGallery")) {
      String path = call.argument("filePath");
      String name = call.argument("name");
      result.success(saveFileToGallery(path, name));
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  private Map<String, Object> saveImageToGallery(Bitmap bitmap, int quality, String name) {
    Map<String, Object> result = new HashMap<>();
    try {
      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        ContentResolver resolver = context.getContentResolver();
        ContentValues contentValues = new ContentValues();
        contentValues.put(MediaStore.MediaColumns.DISPLAY_NAME, name != null ? name : System.currentTimeMillis() + ".jpg");
        contentValues.put(MediaStore.MediaColumns.MIME_TYPE, "image/jpeg");
        contentValues.put(MediaStore.MediaColumns.RELATIVE_PATH, Environment.DIRECTORY_PICTURES);

        Uri imageUri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues);
        if (imageUri != null) {
          try (OutputStream outputStream = resolver.openOutputStream(imageUri)) {
            bitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStream);
          }
          result.put("isSuccess", true);
          result.put("filePath", imageUri.toString());
        } else {
          result.put("isSuccess", false);
          result.put("errorMessage", "Failed to create new MediaStore record");
        }
      } else {
        File directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES);
        if (!directory.exists()) {
          directory.mkdirs();
        }
        String fileName = name != null ? name : System.currentTimeMillis() + ".jpg";
        File file = new File(directory, fileName);
        try (FileOutputStream outputStream = new FileOutputStream(file)) {
          bitmap.compress(Bitmap.CompressFormat.JPEG, quality, outputStream);
        }
        result.put("isSuccess", true);
        result.put("filePath", file.getAbsolutePath());
      }
    } catch (Exception e) {
      Log.e("ImageGallerySaverPlugin", "Error saving image", e);
      result.put("isSuccess", false);
      result.put("errorMessage", e.getMessage());
    }
    return result;
  }

  private Map<String, Object> saveFileToGallery(String filePath, String name) {
    Map<String, Object> result = new HashMap<>();
    try {
      File file = new File(filePath);
      if (!file.exists()) {
        result.put("isSuccess", false);
        result.put("errorMessage", "File does not exist: " + filePath);
        return result;
      }

      String fileName = name != null ? name : file.getName();
      String mimeType = getMimeType(filePath);
      String directoryPath = getDirectoryForMimeType(mimeType);

      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
        ContentResolver resolver = context.getContentResolver();
        ContentValues contentValues = new ContentValues();
        contentValues.put(MediaStore.MediaColumns.DISPLAY_NAME, fileName);
        contentValues.put(MediaStore.MediaColumns.MIME_TYPE, mimeType);
        contentValues.put(MediaStore.MediaColumns.RELATIVE_PATH, directoryPath);

        Uri contentUri = getContentUriForMimeType(mimeType);
        Uri fileUri = resolver.insert(contentUri, contentValues);
        if (fileUri != null) {
          try (OutputStream outputStream = resolver.openOutputStream(fileUri);
               FileInputStream inputStream = new FileInputStream(file)) {
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) > 0) {
              outputStream.write(buffer, 0, length);
            }
          }
          result.put("isSuccess", true);
          result.put("filePath", fileUri.toString());
        } else {
          result.put("isSuccess", false);
          result.put("errorMessage", "Failed to create new MediaStore record");
        }
      } else {
        File directoryFile = Environment.getExternalStoragePublicDirectory(directoryPath);
        if (!directoryFile.exists()) {
          directoryFile.mkdirs();
        }
        File destFile = new File(directoryFile, fileName);
        try (FileOutputStream outputStream = new FileOutputStream(destFile);
             FileInputStream inputStream = new FileInputStream(file)) {
          byte[] buffer = new byte[1024];
          int length;
          while ((length = inputStream.read(buffer)) > 0) {
            outputStream.write(buffer, 0, length);
          }
        }
        result.put("isSuccess", true);
        result.put("filePath", destFile.getAbsolutePath());
      }
    } catch (IOException e) {
      Log.e("ImageGallerySaverPlugin", "Error saving file", e);
      result.put("isSuccess", false);
      result.put("errorMessage", e.getMessage());
    }
    return result;
  }

  private String getMimeType(String filePath) {
    if (filePath.endsWith(".jpg") || filePath.endsWith(".jpeg")) {
      return "image/jpeg";
    } else if (filePath.endsWith(".png")) {
      return "image/png";
    } else if (filePath.endsWith(".gif")) {
      return "image/gif";
    } else if (filePath.endsWith(".mp4")) {
      return "video/mp4";
    } else if (filePath.endsWith(".avi")) {
      return "video/avi";
    } else if (filePath.endsWith(".mov")) {
      return "video/quicktime";
    } else {
      return "*/*";
    }
  }

  private String getDirectoryForMimeType(String mimeType) {
    if (mimeType.startsWith("image/")) {
      return Environment.DIRECTORY_PICTURES;
    } else if (mimeType.startsWith("video/")) {
      return Environment.DIRECTORY_MOVIES;
    } else {
      return Environment.DIRECTORY_DOWNLOADS;
    }
  }

  private Uri getContentUriForMimeType(String mimeType) {
    if (mimeType.startsWith("image/")) {
      return MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
    } else if (mimeType.startsWith("video/")) {
      return MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
    } else {
      return MediaStore.Downloads.EXTERNAL_CONTENT_URI;
    }
  }
}
