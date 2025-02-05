//
//  CameraModel.swift
//  SwiftCamera
//
//  Created by moumen isawe on 21/03/2022.
//

 
import SwiftUI
import Combine
import AVFoundation

final class CameraModel: ObservableObject {
    private let service = CameraService()
    
    @Published var photo: Photo!
    @Published var videoUrl: String!
    
    @Published var showAlertError = false
    
    @Published var isFlashOn = false
    
    @Published var willCapturePhoto = false
    
    var alertError: AlertError!
    
    var session: AVCaptureSession
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        self.session = service.session
        
        service.$photo.sink { [weak self] (photo) in
            guard let pic = photo else { return }
            self?.photo = pic
        }
        .store(in: &self.subscriptions)
        
        
        service.$videoURL.sink { [weak self] (url) in
            guard let url = url else { return }
            self?.videoUrl = url
            print("Fuck you \(url)")
        }
        .store(in: &self.subscriptions)
        
        
        service.$shouldShowAlertView.sink { [weak self] (val) in
            self?.alertError = self?.service.alertError
            self?.showAlertError = val
        }
        .store(in: &self.subscriptions)
        
        service.$flashMode.sink { [weak self] (mode) in
            self?.isFlashOn = mode == .on
        }
        .store(in: &self.subscriptions)
        
        service.$willCapturePhoto.sink { [weak self] (val) in
            self?.willCapturePhoto = val
        }
        .store(in: &self.subscriptions)
    }
    
    func configure() {
        service.checkForPermissions()
        service.configure()
    }
    
    func capturePhoto() {
        service.capturePhoto()
    }
    
    
    func recordVideo() {
        service.record()
    }
    func stopRecording() {
        service.stopRecord()
    }
    func flipCamera() {
        service.changeCamera()
    }
    
    func zoom(with factor: CGFloat) {
        service.set(zoom: factor)
    }
    
    func switchFlash() {
        service.flashMode = service.flashMode == .on ? .off : .on
    }
}
