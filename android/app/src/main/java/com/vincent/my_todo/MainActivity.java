package com.vincent.my_todo;

import android.os.Bundle;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

  }
}
