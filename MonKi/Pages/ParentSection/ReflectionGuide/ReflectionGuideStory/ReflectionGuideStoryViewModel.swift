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
            // Page 1
            ReflectionPage(
                title: "#1",
                subtitle: "Tanya alasan di balik pilihan anak...",
                cards: [
                    ReflectionCard(
                        title: "Contoh pertanyaan:",
                        mainTextPrefix: "“Mama/papa pengen tahu kenapa kamu ",
                        mainTextHighlight: "merasa bahagia",
                        mainTextSuffix: " kalau memiliki...",
                        highlightedText: nil,
                        imageName: "icecream_placeholder"
                    ),
                    ReflectionCard(
                        title: "Contoh pertanyaan:",
                        mainTextPrefix: "“Mama/papa pengen tahu kenapa kamu ",
                        mainTextHighlight: "merasa ini berguna",
                        mainTextSuffix: " untuk",
                        highlightedText: "kesehatan",
                        imageName: "icecream_placeholder"
                    )
                ]
            ),
            
            // Page 2
            ReflectionPage(
                title: "#2",
                subtitle: "Jangan lupa, validasi perasaan anak...",
                cards: [
                    ReflectionCard(
                        title: "Contoh pernyataan:",
                        mainTextPrefix: "“Iya, bisa memiliki yang kamu mau emang bikin senang, dan hal yang bikin senang juga penting kok!”",
                        mainTextHighlight: "",
                        mainTextSuffix: "",
                        highlightedText: nil,
                        imageName: "icecream_placeholder"
                    )
                ]
            ),
            
            // ... (rest of your pages) ...
            
            // Page 3
            ReflectionPage(
                title: "#3",
                subtitle: "Waktunya hubungkan ke nilai keluarga...",
                cards: [
                    ReflectionCard(
                        title: "Contoh pernyataan:",
                        mainTextPrefix: "“Di keluarga kita, yang penting tuh hal yang bisa bikin senang tapi juga gak boros, ya.”",
                        mainTextHighlight: "",
                        mainTextSuffix: "",
                        highlightedText: nil,
                        imageName: "icecream_placeholder"
                    ),
                    ReflectionCard(
                        title: "Contoh pernyataan:",
                        mainTextPrefix: "“Keluarga kita lebih suka hal-hal yang bisa dipakai lama, jadi rasa happy-nya bisa awet juga, deh“",
                        mainTextHighlight: "",
                        mainTextSuffix: "",
                        highlightedText: nil,
                        imageName: "icecream_placeholder"
                    )
                ]
            ),
            
            // Page 4
            ReflectionPage(
                title: "#4",
                subtitle: "Sekarang, ajak anak ikut tarik kesimpulan...",
                cards: [
                    ReflectionCard(
                        title: "Contoh pernyataan:",
                        mainTextPrefix: "“Jadi, kalau besok ingin jenis barang kayak gini lagi, kamu bakal kasih tau MonKi kalau ini berguna untuk...”",
                        mainTextHighlight: "",
                        mainTextSuffix: "",
                        highlightedText: nil,
                        imageName: "icecream_placeholder"
                    )
                ]
            )
        ]
    }
    
    /// Moves to the next story page, or finishes if at the end.
    func advanceStory() {
        if currentPageIndex < pages.count - 1 {
            // Move to next page
            currentPageIndex += 1
            startTimer() // Start timer for the new page
        } else {
            // Reached the end, stop timer
            stopTimer()
            self.progress = 1.0
            // You could call a completion handler here to dismiss the view
        }
    }
    
    /// Moves to the previous story page.
    func regressStory() {
        if currentPageIndex > 0 {
            // Move to previous page
            currentPageIndex -= 1
            startTimer() // Start timer for the new page
        } else {
            // Already at the first page, just reset its timer
            startTimer()
        }
    }
    
    // MARK: - Timer Controls
    
    /// Starts or restarts the timer for the current page.
    func startTimer() {
        // Always reset progress to 0 when (re)starting
        self.progress = 0.0
        
        // Invalidate any existing timer
        timerCancellable?.cancel()
        
        // Create a new timer that fires every 0.05 seconds
        timerCancellable = Timer.publish(every: 0.05, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                // Calculate the increment
                let increment = 0.05 / self.pageDuration
                var newProgress = self.progress + increment
                
                if newProgress >= 1.0 {
                    // Progress is complete, advance the story
                    newProgress = 1.0 // Cap it at 1.0
                    self.advanceStory()
                } else {
                    // Update progress
                    self.progress = newProgress
                }
            }
    }
    
    /// Pauses the timer (e.g., on long press)
    func pauseTimer() {
        timerCancellable?.cancel()
    }
    
    /// Resumes the timer (e.g., on long press end)
    func resumeTimer() {
        // We create a new timer that continues from the *current* progress.
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
    
    /// Stops the timer completely (e.g., on disappear)
    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }
}
