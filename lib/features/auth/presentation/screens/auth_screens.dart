import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:so_link/core/theme/app_theme.dart';
import 'package:so_link/core/utils/validators.dart';
import 'package:so_link/core/widgets/app_widgets.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:so_link/features/auth/presentation/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<AuthCubit>().signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('login_screen'),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    const AppLogo(padding: 16, size: 44),
                    Text('Bienvenue sur SoLink', style: AppTextStyles.heading),
                    Text(
                      'Connectez-vous pour retrouver votre communauté.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                    GlassContainer(
                      child: Column(
                        spacing: 12,
                        children: [
                          AppTextField(
                            key: const ValueKey('login_email_field'),
                            controller: _emailController,
                            label: 'E-mail',
                            hint: 'ex : nom@exemple.com',
                            icon: Icons.mail_outline,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.email,
                          ),
                          PasswordField(
                            key: const ValueKey('login_password_field'),
                            controller: _passwordController,
                            validator: Validators.password,
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<AuthCubit, AuthState>(
                      buildWhen: (previous, current) =>
                          previous.isLoading != current.isLoading,
                      builder: (context, state) => PrimaryButton(
                        key: const ValueKey('login_submit_button'),
                        label: 'Se connecter',
                        isLoading: state.isLoading,
                        onPressed: _submit,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Vous n'avez pas de compte ?",
                          style: AppTextStyles.body,
                        ),
                        TextButton(
                          key: const ValueKey('login_register_button'),
                          onPressed: () => context.push('/register'),
                          child: const Text('Créer un compte'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    context.read<AuthCubit>().signUp(
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('register_screen'),
      appBar: AppBar(),
      body: SafeArea(
        child: BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 16,
                children: [
                  const AppLogo(padding: 16, size: 44),
                  Text('Créer un compte', style: AppTextStyles.heading),
                  GlassContainer(
                    child: Column(
                      spacing: 12,
                      children: [
                        AppTextField(
                          key: const ValueKey('register_nom_field'),
                          controller: _nomController,
                          label: 'Nom',
                          hint: 'ex : Djibo',
                          icon: Icons.person_outline,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              Validators.requiredField(value, label: 'Le nom'),
                        ),
                        AppTextField(
                          key: const ValueKey('register_prenom_field'),
                          controller: _prenomController,
                          label: 'Prénom',
                          hint: 'ex : Ismaël',
                          icon: Icons.person_outline,
                          textInputAction: TextInputAction.next,
                          validator: (value) => Validators.requiredField(
                            value,
                            label: 'Le prénom',
                          ),
                        ),
                        AppTextField(
                          key: const ValueKey('register_email_field'),
                          controller: _emailController,
                          label: 'E-mail',
                          hint: 'ex : nom@exemple.com',
                          icon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: Validators.email,
                        ),
                        PasswordField(
                          key: const ValueKey('register_password_field'),
                          controller: _passwordController,
                          validator: Validators.password,
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    buildWhen: (previous, current) =>
                        previous.isLoading != current.isLoading,
                    builder: (context, state) => PrimaryButton(
                      key: const ValueKey('register_submit_button'),
                      label: "S'inscrire",
                      isLoading: state.isLoading,
                      onPressed: _submit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('onboarding_screen'),
      body: SafeArea(
        child: BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              current.errorMessage != null &&
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          },
          builder: (context, state) {
            final user = state.user;
            if (user == null) {
              return const AppLoading();
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                spacing: 16,
                children: [
                  UserAvatar(username: user.displayName, size: 44),
                  Text('Parlez-nous de vous', style: AppTextStyles.heading),
                  Text(
                    'Votre bio aide les autres à vous trouver et à comprendre '
                    'ce que vous faites.',
                    style: AppTextStyles.body,
                    textAlign: TextAlign.center,
                  ),
                  AppTextField(
                    key: const ValueKey('onboarding_bio_field'),
                    controller: _bioController,
                    label: 'Bio',
                    hint: 'ex : Développeur Flutter | passionné de numérique',
                    lines: 5,
                    validator: (value) =>
                        Validators.requiredField(value, label: 'La bio'),
                  ),
                  PrimaryButton(
                    key: const ValueKey('onboarding_submit_button'),
                    label: 'Ajouter ma bio',
                    isLoading: state.isLoading,
                    onPressed: () => context.read<AuthCubit>().completeProfile(
                      bio: _bioController.text,
                    ),
                  ),
                  TextButton(
                    key: const ValueKey('onboarding_signout_button'),
                    onPressed: state.isLoading
                        ? null
                        : () => context.read<AuthCubit>().signOut(),
                    child: const Text('Se déconnecter'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
