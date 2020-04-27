package com.example.deezer_plugin;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;

import androidx.annotation.NonNull;

import com.deezer.sdk.model.Permissions;
import com.deezer.sdk.network.connect.DeezerConnect;
import com.deezer.sdk.network.connect.SessionStore;
import com.deezer.sdk.network.connect.event.DialogListener;
import com.deezer.sdk.network.request.event.DeezerError;
import com.deezer.sdk.player.TrackPlayer;
import com.deezer.sdk.player.event.OnPlayerErrorListener;
import com.deezer.sdk.player.exception.TooManyPlayersExceptions;
import com.deezer.sdk.player.networkcheck.WifiAndMobileNetworkStateChecker;


import java.lang.reflect.Method;
import java.security.Permission;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * DeezerPlugin
 */
public class DeezerPlugin implements FlutterPlugin, ActivityAware, MethodCallHandler {
    private static Activity activity;
    private static Context context;
    private DeezerConnect deezerConnect;
    private TrackPlayer trackPlayer;


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        final MethodChannel channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "deezer_plugin");
        channel.setMethodCallHandler(new DeezerPlugin());
        context = flutterPluginBinding.getApplicationContext();
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "deezer_plugin");
        channel.setMethodCallHandler(new DeezerPlugin());
        context = registrar.context();
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {

    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
        final String method = call.method;
        if (method.equals("connectDeezer")) {
            final String applicationID = call.argument("appId");
            deezerConnect = DeezerConnect.forApp(applicationID).build();
            final String[] permissions = new String[]{Permissions.BASIC_ACCESS, Permissions.MANAGE_LIBRARY, Permissions.LISTENING_HISTORY};
            final DialogListener listener = new DialogListener() {
                @Override
                public void onComplete(Bundle bundle) {
                    SessionStore sessionStore = new SessionStore();
                    sessionStore.save(deezerConnect, DeezerPlugin.context);
                    if (trackPlayer != null){
                        trackPlayer.stop();
                        trackPlayer.release();
                        trackPlayer = null;
                    }
                    try {
                        trackPlayer = new TrackPlayer(DeezerPlugin.activity.getApplication(), deezerConnect, new WifiAndMobileNetworkStateChecker());
                    } catch (TooManyPlayersExceptions tooManyPlayersExceptions) {
                        tooManyPlayersExceptions.printStackTrace();
                    } catch (DeezerError deezerError) {
                        deezerError.printStackTrace();
                    }
                    result.success(true);
                }

                @Override
                public void onCancel() {
                }

                @Override
                public void onException(Exception e) {
                }
            };
            final SessionStore sessionStore = new SessionStore();
            final Boolean restored = sessionStore.restore(deezerConnect, DeezerPlugin.context);
            if (restored && deezerConnect.isSessionValid()) {
                if (trackPlayer != null){
                    trackPlayer.stop();
                    trackPlayer.release();
                    trackPlayer = null;
                }
                try {
                    trackPlayer = new TrackPlayer(DeezerPlugin.activity.getApplication(), deezerConnect, new WifiAndMobileNetworkStateChecker());
                } catch (TooManyPlayersExceptions tooManyPlayersExceptions) {
                    tooManyPlayersExceptions.printStackTrace();
                } catch (DeezerError deezerError) {
                    deezerError.printStackTrace();
                }
                result.success(true);
            } else {
                deezerConnect.authorize(DeezerPlugin.activity, permissions, listener);
            }

        } else if (method.equals("playTrack")) {
            final String trackId = call.argument("trackId");
            trackPlayer.playTrack(Long.parseLong(trackId));
            result.success(true);
        }else if(method.equals("logoutDeezer")){
            deezerConnect.logout(DeezerPlugin.context);
            trackPlayer.stop();
            trackPlayer.release();
            SessionStore sessionStore = new SessionStore();
            sessionStore.save(deezerConnect, DeezerPlugin.context);
            result.success(true);
        } else if (method.equals("play")) {
            trackPlayer.play();
            result.success(true);
        }else if (method.equals("pause")) {
            trackPlayer.pause();
            result.success(true);
        }else {
            result.notImplemented();
        }

    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        trackPlayer.stop();
        trackPlayer.release();
    }
}
