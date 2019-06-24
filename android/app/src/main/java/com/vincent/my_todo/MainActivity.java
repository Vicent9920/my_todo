package com.vincent.my_todo;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.widget.Toast;

import java.util.ArrayList;
import java.util.List;
import java.util.function.Consumer;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(this.getFlutterView(), "channel_native").setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "method_copy":
                            copy((List<String>) call.arguments);
                            break;
                        case "launch_weixin":
                            startWeiXin();
                            break;
                        case "method_share":
                            share((String) call.arguments);
                            break;
                    }
                }
        );
    }

    private void copy(final List<String> args) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN) {
            final ClipboardManager cmb = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
            cmb.setPrimaryClip(ClipData.newPlainText("text", args.get(0)));
            Toast.makeText(MainActivity.this, args.get(1), Toast.LENGTH_SHORT).show();
        }

    }

    private void startWeiXin() {
        Intent intent = new Intent();
        ComponentName cmp = new ComponentName("com.tencent.mm ", "com.tencent.mm.ui.LauncherUI ");
        intent.setAction(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_LAUNCHER);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.setComponent(cmp);
        startActivity(intent);
    }

    private void share(String args) {
        Intent intent = new Intent(Intent.ACTION_SEND);
        intent.setType("text/plain");
        intent.putExtra(Intent.EXTRA_SUBJECT, "WanFlutter");
        intent.putExtra(Intent.EXTRA_TEXT, args);
        startActivity(Intent.createChooser(intent, "分享"));

    }
}
