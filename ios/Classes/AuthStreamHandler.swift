//
//  AuthStreamHandler.swift
//  flutter_ali_auth
//
//  Created by kangkang on 2022/9/30.
//

import Foundation

extension SwiftFlutterAliAuthPlugin: FlutterStreamHandler {
    /**
     * 设置事件流并开始发射事件。
     *
     * 当第一个侦听器注册到关联的 Stream 时调用
     * Flutter 端的这个频道。
     *
     * @param arguments 流的参数。
     * @param events 异步发出事件的回调。 调用
     * 带有 `FlutterError` 的回调以发出错误事件。 调用
     * 带有 `FlutterEndOfEventStream` 的回调，表示不再有
     * 将发出事件。 任何其他值，包括 `nil` 都作为
     *成功的事件。
     * @return 如果设置失败，则返回 FlutterError 实例。
     */
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        if _eventSink == nil {
            _eventSink = events
        }
        return nil
    }

    /**
     * 删除事件流。
     *
     * 当最后一个侦听器从关联的流中注销时调用
     * Flutter 端的这个频道。
     *
     * 通道实现可以使用 `nil` 参数调用此方法
     * 将一对两个连续的设置请求分开。 此类请求对
     * 在 Flutter 热重启期间可能会发生。
     *
     * @param arguments 流的参数。
     * @return 如果拆卸失败，则返回 FlutterError 实例。
     */
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        _eventSink = nil
        return nil
    }

    // MARK: - 发送消息到Flutter侧

    func onSend(_ responseModel: ResponseModel) -> Void {
        self._eventSink!(responseModel.json)
    }
}
