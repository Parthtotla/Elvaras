

import SwiftUI

import Combine

import FirebaseAuth

struct ContentView: View {

    @State private var screen: AuthScreen = .splash

    var body: some View {

        Group {

            switch screen {

            case .splash:

                SplashView {

                    withAnimation(.easeInOut(duration: 0.35)) {

                        screen = .login

                    }

                }

            case .login:

                LoginView(

                    onCreateAccount: {

                        screen = .createAccount

                    },

                    onPhoneLogin: {

                        screen = .phone

                    },

                    onForgotPassword: {

                        screen = .forgotPassword

                    },

                    onLoginSuccess: {

                        screen = .dashboard

                    }

                )

            case .createAccount:

                CreateAccountView(

                    onLogin: {

                        screen = .login

                    },

                    onPhone: {

                        screen = .phone

                    }

                )

            case .phone:

                PhoneNumberView(

                    onOTP: {

                        screen = .otp

                    },

                    onBack: {

                        screen = .login

                    }

                )

            case .otp:

                OTPView(

                    onBack: {

                        screen = .phone

                    }

                )

            case .forgotPassword:

                ForgotPasswordView {

                    screen = .login

                }

            case .dashboard:

                DashboardView()

            }

        }

        .frame(minWidth: 1000, minHeight: 650)

    }

}

// MARK: - Authentication Screens

enum AuthScreen {

    case splash

    case login

    case createAccount

    case phone

    case otp

    case forgotPassword

    case dashboard

}

// MARK: - Brand Colors

extension Color {

    static let elvarasNavy = Color(

        red: 0.08,

        green: 0.15,

        blue: 0.22

    )

    static let elvarasBackground = Color(

        red: 0.96,

        green: 0.97,

        blue: 0.98

    )

}

// MARK: - Splash

struct SplashView: View {

    let onContinue: () -> Void

    @State private var visible = false

    var body: some View {

        ZStack {

            Color(nsColor: .windowBackgroundColor)

                .ignoresSafeArea()

            VStack(spacing: 22) {

                Image("ElvarasLogo")

                    .resizable()

                    .scaledToFit()

                    .frame(width: 125, height: 125)

                VStack(spacing: 8) {

                    Text("ELVARAS")

                        .font(.system(size: 27, weight: .semibold))

                        .tracking(2)

                    Text("Your timetable organizes your notes.")

                        .font(.system(size: 14))

                        .foregroundStyle(.secondary)

                }

            }

            .opacity(visible ? 1 : 0)

            .scaleEffect(visible ? 1 : 0.96)

        }

        .onAppear {

            withAnimation(.easeOut(duration: 0.6)) {

                visible = true

            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {

                onContinue()

            }

        }

    }

}

// MARK: - Auth Container

struct AuthContainer<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {

        self.content = content()

    }

    var body: some View {

        HStack(spacing: 0) {

            // MARK: Branding Side

            ZStack {

                Color.elvarasNavy

                VStack(alignment: .leading, spacing: 24) {

                    Image("ElvarasLogo")

                        .resizable()

                        .scaledToFit()

                        .frame(width: 78, height: 78)

                        .padding(14)

                        .background(.white.opacity(0.96))

                        .clipShape(RoundedRectangle(cornerRadius: 18))

                    Spacer()

                    VStack(alignment: .leading, spacing: 12) {

                        Text("ELVARAS")

                            .font(.system(size: 30, weight: .bold))

                            .tracking(2)

                        Text("Your timetable\norganizes your notes.")

                            .font(.system(size: 23, weight: .medium))

                            .lineSpacing(5)

                        Text("A focused academic workspace designed to keep your learning organized.")

                            .font(.system(size: 14))

                            .foregroundStyle(.white.opacity(0.72))

                            .lineSpacing(4)

                            .frame(maxWidth: 310, alignment: .leading)

                    }

                    Spacer()

                    Text("ELVARAS • STUDENT WORKSPACE")

                        .font(.system(size: 10, weight: .medium))

                        .tracking(1.2)

                        .foregroundStyle(.white.opacity(0.5))

                }

                .foregroundStyle(.white)

                .padding(.horizontal, 58)

                .padding(.vertical, 55)

                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

            }

            .frame(minWidth: 430, idealWidth: 470)

            // MARK: Form Side

            ZStack {

                Color(nsColor: .windowBackgroundColor)

                content

                    .frame(maxWidth: 430)

                    .padding(.horizontal, 55)

            }

            .frame(maxWidth: .infinity)

        }

        .clipShape(RoundedRectangle(cornerRadius: 18))

        .padding(28)

        .background(Color(nsColor: .underPageBackgroundColor))

    }

}

// MARK: - Login

struct LoginView: View {

    let onCreateAccount: () -> Void

    let onPhoneLogin: () -> Void

    let onForgotPassword: () -> Void

    let onLoginSuccess: () -> Void

    @State private var email = ""

    @State private var password = ""

    @State private var showPassword = false

    var body: some View {

        AuthContainer {

            VStack(alignment: .leading, spacing: 0) {

                Text("Welcome back")

                    .font(.system(size: 30, weight: .bold))

                Text("Continue to your academic workspace.")

                    .font(.system(size: 14))

                    .foregroundStyle(.secondary)

                    .padding(.top, 7)

                    .padding(.bottom, 30)

                GoogleButton()

                DividerWithText(text: "OR")

                    .padding(.vertical, 20)

                FieldLabel("Email")

                TextField("name@example.com", text: $email)

                    .textFieldStyle(.plain)

                    .padding(12)

                    .background(Color.primary.opacity(0.045))

                    .overlay(

                        RoundedRectangle(cornerRadius: 9)

                            .stroke(Color.primary.opacity(0.10))

                    )

                    .clipShape(RoundedRectangle(cornerRadius: 9))

                FieldLabel("Password")

                    .padding(.top, 17)

                HStack {

                    if showPassword {

                        TextField("Enter your password", text: $password)

                    } else {

                        SecureField("Enter your password", text: $password)

                    }

                    Button {

                        showPassword.toggle()

                    } label: {

                        Image(systemName: showPassword ? "eye.slash" : "eye")

                            .foregroundStyle(.secondary)

                    }

                    .buttonStyle(.plain)

                }

                .padding(12)

                .background(Color.primary.opacity(0.045))

                .overlay(

                    RoundedRectangle(cornerRadius: 9)

                        .stroke(Color.primary.opacity(0.10))

                )

                .clipShape(RoundedRectangle(cornerRadius: 9))

                HStack {

                    Spacer()

                    Button("Forgot password?") {

                        onForgotPassword()

                    }

                    .buttonStyle(.link)

                    .font(.system(size: 12))

                }

                .padding(.top, 9)

                PrimaryButton(title: "Log In →") {

                    Task {

                        do {

                            try await Auth.auth().signIn(

                                withEmail: email,

                                password: password

                            )

                            print("Login successful")

                            onLoginSuccess()

                        } catch {

                            print("Login failed: \(error.localizedDescription)")

                        }

                    }

                }

                .padding(.top, 20)

                Button {

                    onPhoneLogin()

                } label: {

                    Label("Continue with Phone Number", systemImage: "iphone")

                        .frame(maxWidth: .infinity)

                }

                .buttonStyle(SecondaryButtonStyle())

                .padding(.top, 10)

                HStack(spacing: 5) {

                    Text("Don't have an account?")

                        .foregroundStyle(.secondary)

                    Button("Create account") {

                        onCreateAccount()

                    }

                    .buttonStyle(.link)

                }

                .font(.system(size: 12))

                .frame(maxWidth: .infinity)

                .padding(.top, 25)

            }

        }

    }

}

// MARK: - Create Account

struct CreateAccountView: View {

    let onLogin: () -> Void

    let onPhone: () -> Void

    @State private var name = ""

    @State private var email = ""

    @State private var password = ""

    @State private var confirmPassword = ""

    var body: some View {

        AuthContainer {

            VStack(alignment: .leading, spacing: 0) {

                Text("Create your account")

                    .font(.system(size: 29, weight: .bold))

                Text("Set up your personal academic workspace.")

                    .font(.system(size: 14))

                    .foregroundStyle(.secondary)

                    .padding(.top, 7)

                    .padding(.bottom, 25)

                FieldLabel("Full Name")

                TextField("Jane Doe", text: $name)

                    .styledElvarasField()

                FieldLabel("Email")

                    .padding(.top, 14)

                TextField("name@example.com", text: $email)

                    .styledElvarasField()

                FieldLabel("Password")

                    .padding(.top, 14)

                SecureField("Create a password", text: $password)

                    .styledElvarasField()

                FieldLabel("Confirm Password")

                    .padding(.top, 14)

                SecureField("Confirm your password", text: $confirmPassword)

                    .styledElvarasField()

                PrimaryButton(title: "Create Account →") {

                    guard password == confirmPassword else {

                        print("Passwords do not match")

                        return

                    }

                    Task {

                        do {

                            let result = try await Auth.auth().createUser(

                                withEmail: email,

                                password: password

                            )

                            print("Account created: \(result.user.uid)")

                        } catch {

                            print("Account creation failed: \(error.localizedDescription)")

                        }

                    }

                }

                .padding(.top, 20)

                DividerWithText(text: "OR")

                    .padding(.vertical, 16)

                GoogleButton()

                Button {

                    onPhone()

                } label: {

                    Label("Continue with Phone Number", systemImage: "iphone")

                        .frame(maxWidth: .infinity)

                }

                .buttonStyle(SecondaryButtonStyle())

                .padding(.top, 9)

                HStack(spacing: 5) {

                    Text("Already have an account?")

                        .foregroundStyle(.secondary)

                    Button("Log in") {

                        onLogin()

                    }

                    .buttonStyle(.link)

                }

                .font(.system(size: 12))

                .frame(maxWidth: .infinity)

                .padding(.top, 20)

            }

        }

    }

}

// MARK: - Phone Number

struct PhoneNumberView: View {

    let onOTP: () -> Void

    let onBack: () -> Void

    @State private var phone = ""

    @State private var country = "+91"

    var body: some View {

        AuthContainer {

            VStack(alignment: .leading, spacing: 0) {

                Button {

                    onBack()

                } label: {

                    Image(systemName: "chevron.left")

                }

                .buttonStyle(.plain)

                .foregroundStyle(.secondary)

                .padding(.bottom, 24)

                Text("Enter your phone number")

                    .font(.system(size: 29, weight: .bold))

                Text("We'll send a verification code to secure your account.")

                    .font(.system(size: 14))

                    .foregroundStyle(.secondary)

                    .padding(.top, 7)

                    .padding(.bottom, 30)

                FieldLabel("Country")

                HStack {

                    Text("🇮🇳")

                    Text(country)

                    Spacer()

                    Image(systemName: "chevron.down")

                        .foregroundStyle(.secondary)

                }

                .padding(12)

                .background(Color.primary.opacity(0.045))

                .overlay(

                    RoundedRectangle(cornerRadius: 9)

                        .stroke(Color.primary.opacity(0.10))

                )

                .clipShape(RoundedRectangle(cornerRadius: 9))

                FieldLabel("Phone Number")

                    .padding(.top, 17)

                HStack(spacing: 8) {

                    Text(country)

                        .foregroundStyle(.secondary)

                    TextField("98765 43210", text: $phone)

                }

                .styledElvarasField()

                PrimaryButton(title: "Send OTP →") {

                    onOTP()

                }

                .padding(.top, 22)

                HStack(spacing: 7) {

                    Image(systemName: "lock.shield")

                    Text("Your number is securely protected.")

                }

                .font(.system(size: 11))

                .foregroundStyle(.secondary)

                .frame(maxWidth: .infinity)

                .padding(.top, 16)

                Button("Use another sign-in method") {

                    onBack()

                }

                .buttonStyle(.link)

                .font(.system(size: 12))

                .frame(maxWidth: .infinity)

                .padding(.top, 25)

            }

        }

    }

}

// MARK: - OTP

struct OTPView: View {

    let onBack: () -> Void

    @State private var otp = ""

    @State private var countdown = 45

    var body: some View {

        AuthContainer {

            VStack(alignment: .leading, spacing: 0) {

                Button {

                    onBack()

                } label: {

                    Image(systemName: "chevron.left")

                }

                .buttonStyle(.plain)

                .foregroundStyle(.secondary)

                .padding(.bottom, 24)

                Text("Verify your phone number")

                    .font(.system(size: 29, weight: .bold))

                Text("We sent a 6-digit verification code to")

                    .font(.system(size: 14))

                    .foregroundStyle(.secondary)

                    .padding(.top, 7)

                Text("+91 ••••• ••210")

                    .font(.system(size: 14, weight: .medium))

                    .padding(.top, 4)

                    .padding(.bottom, 30)

                FieldLabel("Verification Code")

                HStack(spacing: 9) {

                    ForEach(0..<6, id: \.self) { index in

                        OTPBox(

                            character: character(at: index),

                            isActive: otp.count == index

                        )

                    }

                }

                PrimaryButton(title: "Verify →") {

                    // OTP verification will be connected later.

                }

                .padding(.top, 22)

                HStack {

                    Spacer()

                    if countdown > 0 {

                        Text("Resend code in 00:\(String(format: "%02d", countdown))")

                            .foregroundStyle(.secondary)

                    } else {

                        Button("Resend code") {

                            countdown = 45

                        }

                        .buttonStyle(.link)

                    }

                    Spacer()

                }

                .font(.system(size: 12))

                .padding(.top, 17)

                Button("Change phone number") {

                    onBack()

                }

                .buttonStyle(.link)

                .font(.system(size: 12))

                .frame(maxWidth: .infinity)

                .padding(.top, 15)

            }

            .onReceive(

                Timer.publish(every: 1, on: .main, in: .common).autoconnect()

            ) { _ in

                if countdown > 0 {

                    countdown -= 1

                }

            }

        }

    }

    private func character(at index: Int) -> String {

        guard index < otp.count else {

            return ""

        }

        let stringIndex = otp.index(otp.startIndex, offsetBy: index)

        return String(otp[stringIndex])

    }

}

// MARK: - OTP Box

struct OTPBox: View {

    let character: String

    let isActive: Bool

    var body: some View {

        Text(character)

            .font(.system(size: 22, weight: .semibold))

            .frame(width: 48, height: 54)

            .background(Color.primary.opacity(0.045))

            .overlay(

                RoundedRectangle(cornerRadius: 9)

                    .stroke(

                        isActive

                        ? Color.elvarasNavy

                        : Color.primary.opacity(0.12),

                        lineWidth: isActive ? 1.5 : 1

                    )

            )

            .clipShape(RoundedRectangle(cornerRadius: 9))

    }

}

// MARK: - Forgot Password

struct ForgotPasswordView: View {

    let onBack: () -> Void

    @State private var email = ""

    var body: some View {

        AuthContainer {

            VStack(alignment: .leading, spacing: 0) {

                Button {

                    onBack()

                } label: {

                    Image(systemName: "chevron.left")

                }

                .buttonStyle(.plain)

                .foregroundStyle(.secondary)

                .padding(.bottom, 24)

                Text("Reset your password")

                    .font(.system(size: 29, weight: .bold))

                Text("Enter your email address and we'll send you a secure reset link.")

                    .font(.system(size: 14))

                    .foregroundStyle(.secondary)

                    .lineSpacing(3)

                    .padding(.top, 7)

                    .padding(.bottom, 30)

                FieldLabel("Email")

                TextField("name@example.com", text: $email)

                    .styledElvarasField()

                PrimaryButton(title: "Send Reset Link →") {

                    // Password reset will be connected later.

                }

                .padding(.top, 22)

                Button("Back to Login") {

                    onBack()

                }

                .buttonStyle(.link)

                .font(.system(size: 12))

                .frame(maxWidth: .infinity)

                .padding(.top, 25)

            }

        }

    }

}

// MARK: - Components

struct FieldLabel: View {

    let title: String

    init(_ title: String) {

        self.title = title

    }

    var body: some View {

        Text(title)

            .font(.system(size: 12, weight: .medium))

            .foregroundStyle(.secondary)

            .padding(.bottom, 6)

    }

}

struct PrimaryButton: View {

    let title: String

    let action: () -> Void

    var body: some View {

        Button(action: action) {

            Text(title)

                .font(.system(size: 14, weight: .semibold))

                .frame(maxWidth: .infinity)

                .padding(.vertical, 12)

        }

        .buttonStyle(.plain)

        .foregroundStyle(.white)

        .background(Color.elvarasNavy)

        .clipShape(RoundedRectangle(cornerRadius: 9))

    }

}

struct SecondaryButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {

        configuration.label

            .font(.system(size: 13, weight: .medium))

            .foregroundStyle(.primary)

            .padding(.vertical, 11)

            .background(Color.primary.opacity(configuration.isPressed ? 0.09 : 0.045))

            .overlay(

                RoundedRectangle(cornerRadius: 9)

                    .stroke(Color.primary.opacity(0.10))

            )

            .clipShape(RoundedRectangle(cornerRadius: 9))

    }

}

struct GoogleButton: View {

    var body: some View {

        Button {

            // Google authentication will be connected later.

        } label: {

            HStack {

                Text("G")

                    .font(.system(size: 17, weight: .bold))

                Text("Continue with Google")

                    .font(.system(size: 13, weight: .medium))

            }

            .frame(maxWidth: .infinity)

        }

        .buttonStyle(SecondaryButtonStyle())

    }

}

struct DividerWithText: View {

    let text: String

    var body: some View {

        HStack(spacing: 12) {

            Rectangle()

                .frame(height: 1)

                .foregroundStyle(Color.primary.opacity(0.08))

            Text(text)

                .font(.system(size: 10, weight: .medium))

                .foregroundStyle(.secondary)

            Rectangle()

                .frame(height: 1)

                .foregroundStyle(Color.primary.opacity(0.08))

        }

    }

}

// MARK: - TextField Styling

extension View {

    func styledElvarasField() -> some View {

        self

            .textFieldStyle(.plain)

            .padding(11)

            .background(Color.primary.opacity(0.045))

            .overlay(

                RoundedRectangle(cornerRadius: 9)

                    .stroke(Color.primary.opacity(0.10))

            )

            .clipShape(RoundedRectangle(cornerRadius: 9))

    }

}

// MARK: - Preview

#Preview {

    ContentView()

}


// MARK: - Elvaras Workspace

enum WorkspaceSection: String, CaseIterable {
    case dashboard = "Dashboard"
    case timetable = "Timetable"
    case subjects = "Subjects"
    case notes = "Notes"
    case tasks = "Tasks"
    case notifications = "Notifications"
    case settings = "Settings"
}

struct DashboardView: View {
    @State private var section: WorkspaceSection = .dashboard
    @State private var showAddClass = false
    @State private var showAddTask = false
    @State private var searchText = ""

    var body: some View {
        WorkspaceShell(
            section: $section,
            searchText: $searchText,
            onAddClass: { showAddClass = true },
            onAddTask: { showAddTask = true }
        ) {
            switch section {
            case .dashboard:
                WorkspaceDashboard(
                    onTimetable: { section = .timetable },
                    onTasks: { section = .tasks },
                    onAddClass: { showAddClass = true },
                    onAddTask: { showAddTask = true }
                )
            case .timetable:
                TimetableWorkspace(onAddClass: { showAddClass = true })
            case .subjects:
                SubjectsWorkspace()
            case .notes:
                NotesWorkspace()
            case .tasks:
                TasksWorkspace(onAddTask: { showAddTask = true })
            case .notifications:
                NotificationsWorkspace()
            case .settings:
                SettingsWorkspace()
            }
        }
        .sheet(isPresented: $showAddClass) {
            AddClassSheet()
        }
        .sheet(isPresented: $showAddTask) {
            AddTaskSheet()
        }
    }
}

// MARK: - Workspace Shell

struct WorkspaceShell<Content: View>: View {
    @Binding var section: WorkspaceSection
    @Binding var searchText: String
    let onAddClass: () -> Void
    let onAddTask: () -> Void
    @ViewBuilder let content: () -> Content

    private let navy = Color(red: 0.031, green: 0.086, blue: 0.145)
    private let background = Color(red: 0.973, green: 0.976, blue: 1.0)
    private let surfaceLow = Color(red: 0.937, green: 0.957, blue: 1.0)
    private let surfaceHigh = Color(red: 0.867, green: 0.914, blue: 1.0)
    private let border = Color(red: 0.769, green: 0.776, blue: 0.800)
    private let secondaryText = Color(red: 0.267, green: 0.278, blue: 0.298)

    var body: some View {
        HStack(spacing: 0) {
            sidebar

            VStack(spacing: 0) {
                topBar

                ScrollView {
                    content()
                        .padding(.horizontal, 28)
                        .padding(.vertical, 28)
                        .frame(maxWidth: 1180)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .background(background)
            }
        }
        .background(background)
        .foregroundStyle(Color(red: 0.051, green: 0.110, blue: 0.184))
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(navy)
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text("ELVARAS")
                        .font(.system(size: 18, weight: .bold))
                    Text("Academic Workspace")
                        .font(.system(size: 12))
                        .foregroundStyle(secondaryText)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)

            Button {
                onAddTask()
            } label: {
                Label("Add New Task", systemImage: "plus")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(DashboardPrimaryButtonStyle())
            .padding(.horizontal, 16)
            .padding(.bottom, 18)

            VStack(spacing: 4) {
                workspaceItem(.dashboard, "square.grid.2x2")
                workspaceItem(.timetable, "calendar")
                workspaceItem(.subjects, "books.vertical")
                workspaceItem(.notes, "doc.text")
                workspaceItem(.tasks, "checkmark.circle")
            }

            Spacer()

            VStack(spacing: 4) {
                workspaceItem(.notifications, "bell")
                workspaceItem(.settings, "gearshape")
            }
            .padding(.top, 16)
            .overlay(alignment: .top) {
                Rectangle()
                    .fill(border.opacity(0.55))
                    .frame(height: 1)
            }
        }
        .padding(.vertical, 24)
        .frame(width: 260)
        .background(surfaceLow)
        .overlay(alignment: .trailing) {
            Rectangle()
                .fill(border)
                .frame(width: 1)
        }
    }

    private func workspaceItem(_ item: WorkspaceSection, _ icon: String) -> some View {
        Button {
            section = item
        } label: {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: section == item ? .semibold : .regular))
                    .frame(width: 20)

                Text(item.rawValue)
                    .font(.system(size: 14, weight: section == item ? .semibold : .regular))

                Spacer()
            }
            .foregroundStyle(section == item ? navy : secondaryText)
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(section == item ? surfaceHigh : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(alignment: .leading) {
                if section == item {
                    Capsule()
                        .fill(navy)
                        .frame(width: 4, height: 20)
                        .offset(x: -12)
                }
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 12)
    }

    private var topBar: some View {
        HStack {
            Text(section.rawValue)
                .font(.system(size: 15, weight: .semibold))

            Spacer()

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 14))
                    .foregroundStyle(secondaryText)

                TextField("Search...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 14))

                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }

                Text("⌘K")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundStyle(secondaryText)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(surfaceHigh)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
            }
            .padding(.horizontal, 12)
            .frame(width: 280, height: 34)
            .background(surfaceLow)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(border.opacity(0.7), lineWidth: 1))

            Button { } label: {
                Image(systemName: "person.circle")
                    .font(.system(size: 23))
                    .foregroundStyle(navy)
            }
            .buttonStyle(.plain)
            .padding(.leading, 8)
        }
        .padding(.horizontal, 24)
        .frame(height: 64)
        .background(background.opacity(0.96))
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(border)
                .frame(height: 1)
        }
    }
}

// MARK: - Dashboard

struct WorkspaceDashboard: View {
    let onTimetable: () -> Void
    let onTasks: () -> Void
    let onAddClass: () -> Void
    let onAddTask: () -> Void

    private let navy = Color(red: 0.031, green: 0.086, blue: 0.145)
    private let surfaceHigh = Color(red: 0.867, green: 0.914, blue: 1.0)
    private let border = Color(red: 0.769, green: 0.776, blue: 0.800)
    private let secondaryText = Color(red: 0.267, green: 0.278, blue: 0.298)

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Good morning, Alex")
                        .font(.system(size: 34, weight: .bold))
                        .tracking(-0.7)

                    Text("Here's what's happening with your studies today.")
                        .font(.system(size: 16))
                        .foregroundStyle(secondaryText)
                }

                Spacer()

                Button(action: onAddClass) {
                    Label("Add Class", systemImage: "plus")
                }
                .buttonStyle(DashboardSecondaryButtonStyle())

                Button(action: onAddTask) {
                    Label("Add Task", systemImage: "checklist")
                }
                .buttonStyle(DashboardPrimaryButtonStyle())
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4), spacing: 16) {
                DashboardStatCard(title: "Today's Classes", value: "3", suffix: "remaining", icon: "graduationcap")
                DashboardStatCard(title: "Pending Tasks", value: "5", suffix: "overdue", icon: "exclamationmark.triangle", error: true)
                DashboardStatCard(title: "Active Subjects", value: "4", suffix: nil, icon: "books.vertical")
                DashboardStatCard(title: "Attendance Avg", value: "94%", suffix: nil, icon: "checkmark.seal")
            }

            HStack(alignment: .top, spacing: 32) {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Today's Schedule")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Button("View Full Timetable", action: onTimetable)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(navy)
                            .buttonStyle(.plain)
                    }
                    .padding(.bottom, 10)
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(border).frame(height: 1)
                    }

                    ScheduleRow(time: "10:00 AM", duration: "1h 30m", title: "Advanced Macroeconomics", room: "Hall B", teacher: "Dr. Smith", highlighted: true)
                    ScheduleRow(time: "1:00 PM", duration: "2h 00m", title: "Data Structures", room: "Lab 4", teacher: "Prof. Lee")
                }
                .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Upcoming Tasks")
                            .font(.system(size: 18, weight: .semibold))
                        Spacer()
                        Button("View All", action: onTasks)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(navy)
                            .buttonStyle(.plain)
                    }
                    .padding(.bottom, 10)
                    .overlay(alignment: .bottom) {
                        Rectangle().fill(border).frame(height: 1)
                    }

                    VStack(spacing: 0) {
                        TaskRow(title: "Read Chapter 4-5 Macro", priority: "High", due: "Due Today", error: true)
                        Divider().overlay(border)
                        TaskRow(title: "Binary Tree Assignment", priority: "Medium", due: "Tomorrow")
                        Divider().overlay(border)
                        TaskRow(title: "Draft Research Proposal", priority: "Low", due: "Next Week")
                    }
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(border, lineWidth: 1))
                }
                .frame(width: 330)
            }
        }
    }
}

struct DashboardStatCard: View {
    let title: String
    let value: String
    let suffix: String?
    let icon: String
    var error: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: icon)
                    .foregroundStyle(error ? Color.red.opacity(0.8) : .secondary)
            }

            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text(value)
                    .font(.system(size: 24, weight: .semibold))
                if let suffix {
                    Text(suffix)
                        .font(.system(size: 14))
                        .foregroundStyle(error ? Color.red.opacity(0.85) : .secondary)
                }
            }

            if title == "Attendance Avg" {
                GeometryReader { proxy in
                    Capsule()
                        .fill(Color(red: 0.867, green: 0.914, blue: 1.0))
                        .overlay(alignment: .leading) {
                            Capsule()
                                .fill(Color(red: 0.031, green: 0.086, blue: 0.145))
                                .frame(width: proxy.size.width * 0.94)
                        }
                }
                .frame(height: 4)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 112, alignment: .topLeading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1))
    }
}

struct ScheduleRow: View {
    let time: String
    let duration: String
    let title: String
    let room: String
    let teacher: String
    var highlighted = false

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(time).font(.system(size: 14, weight: .medium))
                Text(duration).font(.system(size: 12)).foregroundStyle(.secondary)
            }
            .frame(width: 72, alignment: .leading)

            VStack(alignment: .leading, spacing: 7) {
                Text(title).font(.system(size: 18, weight: .semibold))
                HStack(spacing: 16) {
                    Label(room, systemImage: "location")
                    Label(teacher, systemImage: "person")
                }
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1))
        .overlay(alignment: .leading) {
            RoundedRectangle(cornerRadius: 2)
                .fill(highlighted ? Color(red: 0.031, green: 0.086, blue: 0.145) : Color(red: 0.867, green: 0.914, blue: 1.0))
                .frame(width: 4)
                .padding(.vertical, 16)
        }
    }
}

struct TaskRow: View {
    let title: String
    let priority: String
    let due: String
    var error = false

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Button { } label: {
                Image(systemName: "square")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.system(size: 14))
                    .lineLimit(1)

                HStack(spacing: 7) {
                    Text(priority)
                        .font(.system(size: 10, weight: .semibold, design: .monospaced))
                        .foregroundStyle(error ? Color.red : .secondary)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 3)
                        .background(error ? Color.red.opacity(0.10) : Color(red: 0.867, green: 0.914, blue: 1.0))
                        .clipShape(Capsule())

                    Text(due)
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding(14)
    }
}

// MARK: - Timetable

struct TimetableWorkspace: View {
    let onAddClass: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            PageHeader(
                title: "Timetable",
                subtitle: "Plan your week and keep every class in one place.",
                actionTitle: "Add Class",
                actionIcon: "plus",
                action: onAddClass
            )

            HStack(spacing: 10) {
                ForEach(["Mon", "Tue", "Wed", "Thu", "Fri"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 9)
                        .background(day == "Mon" ? Color(red: 0.867, green: 0.914, blue: 1.0) : Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.25), lineWidth: 1))
                }
            }

            VStack(spacing: 12) {
                TimetableClassCard(time: "10:00 AM", subject: "Advanced Macroeconomics", room: "Hall B", teacher: "Dr. Smith")
                TimetableClassCard(time: "1:00 PM", subject: "Data Structures", room: "Lab 4", teacher: "Prof. Lee")
            }

            EmptyActionCard(
                icon: "calendar.badge.plus",
                title: "Add more classes",
                message: "Build your weekly timetable so your notes can follow your schedule.",
                buttonTitle: "Add Class",
                action: onAddClass
            )
        }
    }
}

struct TimetableClassCard: View {
    let time: String
    let subject: String
    let room: String
    let teacher: String

    var body: some View {
        HStack(spacing: 18) {
            Text(time)
                .font(.system(size: 14, weight: .semibold))
                .frame(width: 85, alignment: .leading)

            VStack(alignment: .leading, spacing: 6) {
                Text(subject).font(.system(size: 16, weight: .semibold))
                HStack(spacing: 16) {
                    Label(room, systemImage: "location")
                    Label(teacher, systemImage: "person")
                }
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1))
    }
}

// MARK: - Subjects

struct SubjectsWorkspace: View {
    private let subjects = [
        ("Advanced Macroeconomics", "Macro", "12 notes"),
        ("Data Structures", "CS", "8 notes"),
        ("Engineering Mathematics", "Math", "6 notes"),
        ("Business Communication", "BC", "4 notes")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            PageHeader(title: "Subjects", subtitle: "Organize chapters, lectures and notes by subject.")

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(subjects, id: \.0) { subject in
                    SubjectCard(name: subject.0, code: subject.1, notes: subject.2)
                }
            }
        }
    }
}

struct SubjectCard: View {
    let name: String
    let code: String
    let notes: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.867, green: 0.914, blue: 1.0))
                Text(code)
                    .font(.system(size: 12, weight: .bold))
            }
            .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 5) {
                Text(name).font(.system(size: 15, weight: .semibold))
                Text(notes).font(.system(size: 12)).foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1))
    }
}

// MARK: - Notes

struct NotesWorkspace: View {
    @State private var selectedNote: String?

    private let notes = [
        ("Macroeconomics - Chapter 4", "Advanced Macroeconomics", "Updated today"),
        ("Binary Trees", "Data Structures", "Updated yesterday"),
        ("Communication Models", "Business Communication", "Updated 3 days ago")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            HStack {
                PageHeader(title: "Notes", subtitle: "Your notes, organized around your subjects and lectures.")
                Spacer()
                Button {
                    selectedNote = "New Note"
                } label: {
                    Label("Create Note", systemImage: "plus")
                }
                .buttonStyle(DashboardPrimaryButtonStyle())
            }

            VStack(spacing: 0) {
                ForEach(notes, id: \.0) { note in
                    Button {
                        selectedNote = note.0
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 20))
                                .foregroundStyle(Color(red: 0.031, green: 0.086, blue: 0.145))

                            VStack(alignment: .leading, spacing: 5) {
                                Text(note.0)
                                    .font(.system(size: 14, weight: .semibold))
                                Text("\(note.1) • \(note.2)")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(16)
                    }
                    .buttonStyle(.plain)

                    if note.0 != notes.last?.0 {
                        Divider()
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1))
        }
        .sheet(item: Binding(
            get: { selectedNote.map { NoteSelection(title: $0) } },
            set: { selectedNote = $0?.title }
        )) { item in
            NoteDetailSheet(title: item.title)
        }
    }
}

struct NoteSelection: Identifiable {
    let id = UUID()
    let title: String
}

struct NoteDetailSheet: View {
    let title: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Button("Done") { dismiss() }
            }

            Text("This is your note workspace. Add lecture content, key points and references here.")
                .foregroundStyle(.secondary)

            TextEditor(text: .constant(""))
                .frame(minHeight: 260)
                .padding(8)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray.opacity(0.25)))
        }
        .padding(28)
        .frame(width: 600, height: 400)
    }
}

// MARK: - Tasks

struct TasksWorkspace: View {
    let onAddTask: () -> Void
    @State private var completed: Set<String> = []

    private let tasks = [
        ("Read Chapter 4-5 Macro", "High", "Due Today"),
        ("Binary Tree Assignment", "Medium", "Tomorrow"),
        ("Draft Research Proposal", "Low", "Next Week")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            PageHeader(
                title: "Tasks",
                subtitle: "Stay on top of assignments, revision and deadlines.",
                actionTitle: "Add Task",
                actionIcon: "plus",
                action: onAddTask
            )

            VStack(spacing: 0) {
                ForEach(tasks, id: \.0) { task in
                    HStack(spacing: 12) {
                        Button {
                            if completed.contains(task.0) {
                                completed.remove(task.0)
                            } else {
                                completed.insert(task.0)
                            }
                        } label: {
                            Image(systemName: completed.contains(task.0) ? "checkmark.square.fill" : "square")
                                .font(.system(size: 18))
                        }
                        .buttonStyle(.plain)

                        VStack(alignment: .leading, spacing: 6) {
                            Text(task.0)
                                .font(.system(size: 14, weight: .medium))
                                .strikethrough(completed.contains(task.0))
                            HStack(spacing: 8) {
                                Text(task.1)
                                    .font(.system(size: 10, weight: .semibold, design: .monospaced))
                                    .padding(.horizontal, 7)
                                    .padding(.vertical, 3)
                                    .background(task.1 == "High" ? Color.red.opacity(0.10) : Color(red: 0.867, green: 0.914, blue: 1.0))
                                    .clipShape(Capsule())
                                Text(task.2)
                                    .font(.system(size: 12))
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()
                    }
                    .padding(16)

                    if task.0 != tasks.last?.0 {
                        Divider()
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1))
        }
    }
}

// MARK: - Notifications

struct NotificationsWorkspace: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            PageHeader(title: "Notifications", subtitle: "Important updates from your academic workspace.")

            VStack(spacing: 0) {
                NotificationRow(icon: "calendar.badge.clock", title: "Class starting soon", message: "Data Structures starts at 1:00 PM.", time: "10 min ago")
                Divider()
                NotificationRow(icon: "checkmark.circle", title: "Task due today", message: "Read Chapter 4-5 Macro is due today.", time: "1 hr ago")
                Divider()
                NotificationRow(icon: "note.text", title: "Notes updated", message: "Your recent notes are ready to review.", time: "Yesterday")
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1))
        }
    }
}

struct NotificationRow: View {
    let icon: String
    let title: String
    let message: String
    let time: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .frame(width: 36, height: 36)
                .background(Color(red: 0.867, green: 0.914, blue: 1.0))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 5) {
                Text(title).font(.system(size: 14, weight: .semibold))
                Text(message).font(.system(size: 12)).foregroundStyle(.secondary)
            }

            Spacer()
            Text(time).font(.system(size: 11)).foregroundStyle(.secondary)
        }
        .padding(16)
    }
}

// MARK: - Settings

struct SettingsWorkspace: View {
    @State private var notificationsEnabled = true
    @State private var compactMode = false
    @State private var showDeleteConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            PageHeader(title: "Settings", subtitle: "Customize your ELVARAS workspace.")

            SettingsGroup(title: "General") {
                SettingToggleRow(
                    title: "Notifications",
                    subtitle: "Receive reminders for classes and tasks.",
                    isOn: $notificationsEnabled
                )

                Divider()

                SettingToggleRow(
                    title: "Compact Mode",
                    subtitle: "Use tighter spacing across workspace screens.",
                    isOn: $compactMode
                )
            }

            SettingsGroup(title: "Account") {
                SettingsActionRow(title: "Profile", subtitle: "Manage your name and academic details.", icon: "person.circle")
                Divider()
                SettingsActionRow(title: "Security", subtitle: "Manage your sign-in and password.", icon: "lock")
            }

            SettingsGroup(title: "Danger Zone") {
                Button {
                    showDeleteConfirmation = true
                } label: {
                    HStack {
                        Image(systemName: "trash")
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Delete local workspace")
                                .font(.system(size: 14, weight: .semibold))
                            Text("Remove locally stored timetable and notes.")
                                .font(.system(size: 12))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                    .foregroundStyle(.red)
                    .padding(16)
                }
                .buttonStyle(.plain)
            }
        }
        .alert("Delete local workspace?", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) { }
        } message: {
            Text("This demo action does not delete your Firebase account.")
        }
    }
}

struct SettingsGroup<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))

            VStack(spacing: 0) {
                content()
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1))
        }
    }
}

struct SettingToggleRow: View {
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 14, weight: .medium))
                Text(subtitle).font(.system(size: 12)).foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(16)
    }
}

struct SettingsActionRow: View {
    let title: String
    let subtitle: String
    let icon: String

    var body: some View {
        Button { } label: {
            HStack {
                Image(systemName: icon)
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title).font(.system(size: 14, weight: .medium))
                    Text(subtitle).font(.system(size: 12)).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Shared UI

struct PageHeader: View {
    let title: String
    let subtitle: String
    var actionTitle: String? = nil
    var actionIcon: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.system(size: 30, weight: .bold))
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let actionTitle, let actionIcon, let action {
                Button(action: action) {
                    Label(actionTitle, systemImage: actionIcon)
                }
                .buttonStyle(DashboardPrimaryButtonStyle())
            }
        }
    }
}

struct EmptyActionCard: View {
    let icon: String
    let title: String
    let message: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(.secondary)

            Text(title)
                .font(.system(size: 15, weight: .semibold))

            Text(message)
                .font(.system(size: 12))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button(buttonTitle, action: action)
                .buttonStyle(DashboardPrimaryButtonStyle())
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.25), lineWidth: 1))
    }
}

// MARK: - Add Class

struct AddClassSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var subject = ""
    @State private var room = ""
    @State private var teacher = ""
    @State private var day = "Monday"
    @State private var time = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Add Class")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Button("Cancel") { dismiss() }
            }

            TextField("Subject", text: $subject)
                .styledElvarasField()

            TextField("Room", text: $room)
                .styledElvarasField()

            TextField("Teacher", text: $teacher)
                .styledElvarasField()

            Picker("Day", selection: $day) {
                ForEach(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"], id: \.self) {
                    Text($0)
                }
            }

            DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)

            Button("Save Class") {
                dismiss()
            }
            .buttonStyle(DashboardPrimaryButtonStyle())
        }
        .padding(28)
        .frame(width: 520)
    }
}

// MARK: - Add Task

struct AddTaskSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var priority = "Medium"
    @State private var dueDate = Date()

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("Add Task")
                    .font(.system(size: 22, weight: .bold))
                Spacer()
                Button("Cancel") { dismiss() }
            }

            TextField("Task title", text: $title)
                .styledElvarasField()

            Picker("Priority", selection: $priority) {
                Text("High").tag("High")
                Text("Medium").tag("Medium")
                Text("Low").tag("Low")
            }

            DatePicker("Due date", selection: $dueDate, displayedComponents: .date)

            Button("Create Task") {
                dismiss()
            }
            .buttonStyle(DashboardPrimaryButtonStyle())
        }
        .padding(28)
        .frame(width: 520)
    }
}

// MARK: - Dashboard Button Styles

struct DashboardPrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(
                Color(red: 0.031, green: 0.086, blue: 0.145)
                    .opacity(configuration.isPressed ? 0.85 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct DashboardSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 12, weight: .medium))
            .foregroundStyle(Color(red: 0.051, green: 0.110, blue: 0.184))
            .padding(.horizontal, 14)
            .padding(.vertical, 9)
            .background(configuration.isPressed ? Color.black.opacity(0.07) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.35), lineWidth: 1)
            )
    }
}

#Preview {
    ContentView()
}
