//
//  ParentSectionModalType.swift
//  MonKi
//
//  Created by William on 30/10/25.
//

enum ParentSectionModalType: PopUpModalityProtocol {
    case onRejectButtonTapped(onPrimaryTap: () -> Void = {}, onSecondaryTap: () -> Void = {})
    case onStoryViewCancelButtonTapped(onPrimaryTap: () -> Void = {}, onSecondaryTap: () -> Void = {})
    
    var imageIcon: ImageModalityIcon {
        switch self {
        case .onRejectButtonTapped, .onStoryViewCancelButtonTapped:
            return .monkiThinking
        }
    }

    var title: String {
        switch self {
        case .onRejectButtonTapped:
            return "Mau kasih ruang anak buat cerita dulu?"
        case .onStoryViewCancelButtonTapped:
            return "Gak jadi ngobrol nih?"
        }
    }

    var subtitle: String? {
        switch self {
        case .onRejectButtonTapped, .onStoryViewCancelButtonTapped:
            return "Siapa tahu dari ngobrol ringan, si kecil bisa paham kenapa kamu pilih tolak"
        }
    }

    var primaryButtonTitle: String? {
        switch self {
        case .onRejectButtonTapped:
            return "Siap Ngobrol!"
        case .onStoryViewCancelButtonTapped:
            return "Lanjut ngobrol"
        }
    }

    var secondaryButtonTitle: String? {
        switch self {
        case .onRejectButtonTapped, .onStoryViewCancelButtonTapped:
            return "Tolak aja tanpa ngobrol"
        }
    }

    private var actions: (primary: (() -> Void)?, secondary: (() -> Void)?) {
        switch self {
        case let .onRejectButtonTapped(primary, secondary),
             let .onStoryViewCancelButtonTapped(primary, secondary):
            return (primary, secondary)
        }
    }

    var onPrimaryButtonTap: (() -> Void)? { actions.primary }
    var onSecondaryButtonTap: (() -> Void)? { actions.secondary }
}
