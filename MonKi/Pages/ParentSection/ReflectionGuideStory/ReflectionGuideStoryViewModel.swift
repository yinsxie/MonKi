//
//  ReflectionGuideStoryViewModel.swift
//  MonKi
//
//  Created by Aretha Natalova Wahyudi on 29/10/25.
//

import Foundation
import CoreData
import Combine

class ReflectionGuideStoryViewModel: ObservableObject {
    
    /// The index of the currently visible page.
    @Published var currentPageIndex: Int = 0
    
    /// The list of pages to display.
    @Published var pages: [ReflectionPage] = []
    
    /// Progress of the current story segment (0.0 to 1.0)
    @Published var progress: Double = 0.0
    
    @Published var showModalityOnStoryViewCancelButtonTapped: Bool = false
    
    private let log: MsLog
    private let logRepository: LogRepositoryProtocol

    private let pageDuration: TimeInterval = 5.0
    
    /// The cancellable object for our timer.
    private var timerCancellable: AnyCancellable?
    
    init(log: MsLog) {
        self.log = log
        self.logRepository = LogRepository()
        loadReflectionPages()
    }
    
    func rejectLog() {
        guard let logId = log.id else { return }
        print("Rejected log: \(logId)")
        logRepository.logRejectedByParent(withId: logId)
    }
    
    private func loadReflectionPages() {
        self.pages = [
            ReflectionPage(
                title: "#1",
                subtitle: "Tanya alasan di balik pilihan anak...",
                text: "“Mama/Papa ingin tahu kenapa barang ini bikin merasa bahagia dan merasa barang ini berguna untuk...”",
                imageName: "monki_think_normal"
            ),
            ReflectionPage(
                title: "#2",
                subtitle: "Jangan lupa, validasi perasaan anak...",
                text: "“Bisa punya apa yang kamu mau emang bikin senang, dan hal yang bikin senang juga penting kok!”",
                imageName: "monki_think_smile"
            ),
            ReflectionPage(
                title: "#3",
                subtitle: "Waktunya hubungkan ke nilai keluarga...",
                text: "“Di keluarga kita, yang penting tuh hal yang bisa bikin senang tapi juga gak boros, ya.”",
                imageName: "monki_think_normal"
            ),
            ReflectionPage(
                title: "#4",
                subtitle: "Sekarang, ajak anak ikut tarik kesimpulan...",
                text: "“Jadi, kalau nanti mau barang kayak gini lagi, kamu kasih tau MonKi kalau ini berguna untuk...”",
                imageName: "monki_think_smile"
            )
        ]
    }
    
    /// Moves to the next story page, or finishes if at the end.
    func advanceStory() {
        if currentPageIndex < pages.count - 1 {
            currentPageIndex += 1
            startTimer()
        } else {
            stopTimer()
            self.progress = 1.0
        }
    }
    
    /// Moves to the previous story page.
    func regressStory() {
        if currentPageIndex > 0 {
            currentPageIndex -= 1
            startTimer()
        } else {
            startTimer()
        }
    }
    
    // MARK: - Timer Controls
    
    /// Starts or restarts the timer for the current page.
    func startTimer() {
        self.progress = 0.0
        
        timerCancellable?.cancel()
        
        timerCancellable = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let increment = 0.05 / self.pageDuration
                var newProgress = self.progress + increment
                
                if newProgress >= 1.0 {
                    newProgress = 1.0
                    self.advanceStory()
                } else {
                    self.progress = newProgress
                }
            }
    }
    
    func pauseTimer() {
        timerCancellable?.cancel()
    }
    
    func resumeTimer() {
        timerCancellable = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                let increment = 0.05 / self.pageDuration
                var newProgress = self.progress + increment
                
                if newProgress >= 1.0 {
                    newProgress = 1.0
                    self.advanceStory()
                } else {
                    self.progress = newProgress
                }
            }
    }
    
    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
    
    func setShowModalityOnStoryViewCancelButtonTapped(to state: Bool) {
        showModalityOnStoryViewCancelButtonTapped = state
        if state {
            pauseTimer()
        } else {
            resumeTimer()
        }
    }
}
